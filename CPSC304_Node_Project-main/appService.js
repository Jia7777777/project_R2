const oracledb = require('oracledb');
const fs = require('fs').promises;
const path = require('path');
const loadEnvFile = require('./utils/envUtil');

const envVariables = loadEnvFile('./.env');

// Database configuration setup. Ensure your .env file has the required database credentials.
const dbConfig = {
    user: envVariables.ORACLE_USER,
    password: envVariables.ORACLE_PASS,
    connectString: `${envVariables.ORACLE_HOST}:${envVariables.ORACLE_PORT}/${envVariables.ORACLE_DBNAME}`,
    poolMin: 1,
    poolMax: 3,
    poolIncrement: 1,
    poolTimeout: 60
};

// initialize connection pool
async function initializeConnectionPool() {
    try {
        await oracledb.createPool(dbConfig);
        console.log('Connection pool started');
    } catch (err) {
        console.error('Initialization error: ' + err.message);
    }
}

async function closePoolAndExit() {
    console.log('\nTerminating');
    try {
        await oracledb.getPool().close(10); // 10 seconds grace period for connections to finish
        console.log('Pool closed');
        process.exit(0);
    } catch (err) {
        console.error(err.message);
        process.exit(1);
    }
}

initializeConnectionPool();

process
    .once('SIGTERM', closePoolAndExit)
    .once('SIGINT', closePoolAndExit);


// ----------------------------------------------------------
// Wrapper to manage OracleDB actions, simplifying connection handling.
async function withOracleDB(action) {
    let connection;
    try {
        connection = await oracledb.getConnection(); // Gets a connection from the default pool 
        return await action(connection);
    } catch (err) {
        console.error(err);
        throw err;
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error(err);
            }
        }
    }
}


// ----------------------------------------------------------
// Core functions for database operations
// Modify these functions, especially the SQL queries, based on your project's requirements and design.
async function testOracleConnection() {
    return await withOracleDB(async (connection) => {
        return true;
    }).catch(() => {
        return false;
    });
}

async function fetchTPH1FromDb() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT * FROM TPH1 FETCH FIRST 10 ROWS ONLY');
        return result.rows;
    }).catch(() => {
        return [];
    });
}

// Initiate all data in sql script
async function initiateData() {
    const filePath = path.resolve(__dirname, 'm4_sql.sql');
    const sqlStatements = await fs.readFile(filePath, 'utf8');
    return await withOracleDB(async (connection) => {
        const statements = sqlStatements.split(';');
        let promises = [];
        for (const statement of statements) {
            if(statement.trim()) {
                promises.push(connection.execute(statement.trim(), [], { autoCommit: true }))
            }
        }
        try {
            await Promise.allSettled(promises);
        }
        catch (err) {
            // should not come here    
        }
        
        return true;
    }).catch(() => {
        return false;
    });
}

async function insertTPH(seatnumber, cid, paymentmethod, paymentlocation, email, seatlocation) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `INSERT INTO TPH1 (seatnumber, cid, paymentmethod, paymentlocation, email, seatlocation) VALUES (:seatnumber, :cid, :paymentmethod, :paymentlocation, :email, :seatlocation)`,
            [seatnumber, cid, paymentmethod, paymentlocation, email, seatlocation],
            { autoCommit: true }
        );

        return result.rowsAffected && result.rowsAffected > 0;
    }).catch((e) => {
        console.log(`error${e}`);
        return false;
    });
}

// UPDATE Clause: Update ticket info for TPH1
async function updateFromTicketPurchaseHas(seatnumber, cid, paymentmethod, paymentlocation, email, seatlocation) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `UPDATE TPH1 SET paymentmethod = :paymentmethod, paymentlocation = :paymentlocation, email = :email, seatlocation = :seatlocation where seatnumber = :seatnumber AND cid = :cid`,
            [paymentmethod, paymentlocation, email, seatlocation, seatnumber, cid],
            { autoCommit: true }
        );
        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => {
        return false;
    });
}

// DELETE Clause: Deleting ticket info for TPH1
async function deleteFromTicketPurchaseHas(seatnumber, cid) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `DELETE FROM TPH1 WHERE seatnumber = :seatnumber AND cid = :cid`,
            [seatnumber, cid],
            { autoCommit: true }
        );
        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => {
        return false;
    });
}

// JOIN Clause: Join TPH1 and Concert and SELECT seat numbers that are sold out to the ticket server providing concert title
async function joinTPH1ANDConcert(title) {
    try {
        return await withOracleDB(async (connection) => {
            const query = `
                SELECT t.seatnumber, t.seatlocation
                FROM TPH1 t, Concert c
                WHERE t.cid = c.cid AND c.title = '${title}'
            `;

            const result = await connection.execute(query, [], { autoCommit: true });
            return result.rows.map(row => ({ seatnumber: row[0], seatlocation: row[1] }));
        });
    } catch (err) {
        return [];
    }
}

// GROUP BY Clause: Join TPH1 and Concert, GROUP BY concert title, SELECT concert title and number of tickets sold in that concert
async function AggregationWithGroupBy() {
    try {
        return await withOracleDB(async (connection) => {
            const query = `
                SELECT c.title, COUNT(*)
                FROM TPH1 t, Concert c
                WHERE t.cid = c.cid
                GROUP BY c.title
            `;

            const result = await connection.execute(query, [], { autoCommit: true });
            return result.rows.map(row => ({title: row[0], count: row[1]}));
        });
    } catch (err) {
        return [];
    }
}

// HAVING Clause: Find the email of the audience and number of tickets they have purchased who has purchased at least 1 ticket
async function FindNumberOfTickets() {
    try {
        return await withOracleDB(async (connection) => {
            const query = `
                SELECT a.email, COUNT(*)
                FROM Audience a, TPH1 tph
                WHERE a.email = tph.email
                GROUP BY a.email
                HAVING COUNT(*) >= 1
            `;

            const result = await connection.execute(query, [], { autoCommit: true });
            return result.rows.map(row => ({email: row[0], count: row[1]}));
        });
    } catch (err) {
        return [];
    }
}

async function countDemotable() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT Count(*) FROM DEMOTABLE');
        return result.rows[0][0];
    }).catch(() => {
        return -1;
    });
}

async function selectTPH(parsedString) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(`SELECT * FROM TPH1 WHERE ${parsedString}`);
        return result.rows;
    }).catch(() => {
        return -1;
    });
}

async function projectConcert(s) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(`SELECT ${s} FROM Concert`);
        return result.rows;
    }).catch(() => {
        return -1;
    });
}

module.exports = {
    testOracleConnection,
    fetchTPH1FromDb,
    initiateData, 
    insertTPH, 
    updateFromTicketPurchaseHas, 
    joinTPH1ANDConcert,
    deleteFromTicketPurchaseHas,
    selectTPH,
    AggregationWithGroupBy,
    FindNumberOfTickets,
    projectConcert
};
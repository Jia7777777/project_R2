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

async function fetchDemotableFromDb() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT * FROM DEMOTABLE');
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

        // const result = await connection.execute(`
        //     CREATE TABLE DEMOTABLE (
        //         id NUMBER PRIMARY KEY,
        //         name VARCHAR2(20)
        //     )
        // `);

        // Draft for successfully initializing SQL tables in OracleDB
        //  await connection.execute(
        //      `INSERT INTO DEMOTABLE (id, name) VALUES (12, 'Owen')
        //      `,
        //     [],
        //     { autoCommit: true }
        // );
        return true;
    }).catch(() => {
        return false;
    });
}

async function insertDemotable(id, name) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `INSERT INTO DEMOTABLE (id, name) VALUES (:id, :name)`,
            [id, name],
            { autoCommit: true }
        );

        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => {
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
async function deleteFromTicketPurchaseHas(seatNum, cid) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `DELETE FROM TPH1 WHERE seatnumber=:seatNum AND cid=:cid`,
            [seatNum, cid],
            { autoCommit: true }
        );
        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => {
        return false;
    });
}

async function countDemotable() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT Count(*) FROM DEMOTABLE');
        return result.rows[0][0];
    }).catch(() => {
        return -1;
    });
}

module.exports = {
    testOracleConnection,
    fetchDemotableFromDb,
    initiateData, 
    insertDemotable, 
    updateFromTicketPurchaseHas, 
    countDemotable,
    deleteFromTicketPurchaseHas
};
const express = require('express');
const appService = require('./appService');

const router = express.Router();

// ----------------------------------------------------------
// API endpoints
// Modify or extend these routes based on your project's needs.
router.get('/check-db-connection', async (req, res) => {
    const isConnect = await appService.testOracleConnection();
    if (isConnect) {
        res.send('connected');
    } else {
        res.send('unable to connect');
    }
});

router.get('/TPH1', async (req, res) => {
    const tableContent = await appService.fetchTPH1FromDb();
    res.json({data: tableContent});
});

// POST endpoint for initiating all data in sql script
router.post("/initiate-data", async (req, res) => {
    const initiateResult = await appService.initiateData();
    if (initiateResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

router.post("/insert-TPH", async (req, res) => {
    const { seatnumber, cid, paymentmethod, paymentlocation, email, seatlocation } = req.body;

    const insertResult = await appService.insertTPH(seatnumber, cid, paymentmethod, paymentlocation, email, seatlocation);
    if (insertResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

// POST endpoint for updating concert tickets in TPH1
router.post("/update-tickets", async (req, res) => {
    const { seatnumber, cid, paymentmethod, paymentlocation, email, seatlocation } = req.body;
    const updateResult = await appService.updateFromTicketPurchaseHas(seatnumber, cid, paymentmethod, paymentlocation, email, seatlocation);
    if (updateResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

// POST endpoint for deleting concert tickets from TPH1
router.post("/delete-tickets", async (req, res) => {
    const { seatnumber, cid } = req.body;
    const afterDeletedResult = await appService.deleteFromTicketPurchaseHas(seatnumber, cid);
    if (afterDeletedResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

// GET endpoint for joining concert and TPH1
router.get("/get-unsold-seatInfo", async (req, res) => {
    const title = req.query.title;
    const seatInfo = await appService.joinTPH1ANDConcert(title);
    if (seatInfo.length > 0) {
        res.json({ success: true, seatInfo});
    } else {
        res.json({ success: false, seatInfo: [] });
    }
})

// GET endpoint for GROUP BY clause
router.get("/aggregation-with-group-by", async (req, res) => {
    const info = await appService.AggregationWithGroupBy();
    if (info.length > 0) {
        res.json({ success: true, info});
    } else {
        res.json({ success: false, info: [] });
    }
})

// GET endpoint for HAVING clause
router.get("/retrieve-audiences-who-have-bought-tickets", async (req, res) => {
    const info = await appService.FindNumberOfTickets();
    if (info.length > 0) {
        res.json({ success: true, info});
    } else {
        res.json({ success: false, info: [] });
    }
})

// GET endpoint for Divison clause
router.get("/retrive-audience-who-have-go-to-every-concert", async (req, res) => {
    const info = await appService.Division();
    if (info.length > 0) {
        res.json({ success: true, info});
    } else {
        res.json({ success: false, info: [] });
    }
})

router.post('/selectTPH', async (req, res) => {
    const {parsedString} = req.body;
    const filteredResult = await appService.selectTPH(parsedString);

    if (filteredResult.length >= 0) {
        res.json({ 
            success: true,  
            filteredResult: filteredResult
        });
    } else {
        res.status(500).json({ 
            success: false
        });
    }
})

router.get('/count-demotable', async (req, res) => {
    const {} = req.body;
    const tableCount = await appService.countDemotable();
    if (tableCount >= 0) {
        res.json({ 
            success: true,  
            count: tableCount
        });
    } else {
        res.status(500).json({ 
            success: false, 
            count: tableCount
        });
    }
})

router.get('/projectConcert', async (req, res) => {
    const columnString = req.query.columnString;
    const result = await appService.projectConcert(columnString);
    if (result.length >= 0) {
        res.json({ 
            success: true,  
            projectResult: result
        });
    } else {
        res.status(500).json({ 
            success: false, 
            projectResult: []
        });
    }
});


module.exports = router;
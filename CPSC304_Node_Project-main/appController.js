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

// POST endpoint for joining concert and TPH1
router.post("/get-unsold-seatnumber", async (req, res) => {
    const { title } = req.body;
    const seatnumbers = await appService.joinTPH1ANDConcert(title);
    if (seatnumbers.length > 0) {
        res.json({ success: true, seatnumbers });
    } else {
        res.json({ success: true, seatnumbers: [] });
    }
})

router.get('/count-demotable', async (req, res) => {
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
});


module.exports = router;
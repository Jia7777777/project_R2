/*
 * These functions below are for various webpage functionalities. 
 * Each function serves to process data on the frontend:
 *      - Before sending requests to the backend.
 *      - After receiving responses from the backend.
 * 
 * To tailor them to your specific needs,
 * adjust or expand these functions to match both your 
 *   backend endpoints 
 * and 
 *   HTML structure.
 * 
 */


// This function checks the database connection and updates its status on the frontend.
async function checkDbConnection() {
    const statusElem = document.getElementById('dbStatus');
    const loadingGifElem = document.getElementById('loadingGif');

    const response = await fetch('/check-db-connection', {
        method: "GET"
    });

    // Hide the loading GIF once the response is received.
    loadingGifElem.style.display = 'none';
    // Display the statusElem's text in the placeholder.
    statusElem.style.display = 'inline';

    response.text()
    .then((text) => {
        statusElem.textContent = text;
    })
    .catch((error) => {
        statusElem.textContent = 'connection timed out';  // Adjust error handling if required.
    });
}

// Fetches data from the demotable and displays it.
async function fetchAndDisplayUsers() {
    const tableElement = document.getElementById('TPH1');
    const tableBody = tableElement.querySelector('tbody');

    const response = await fetch('/TPH1', {
        method: 'GET'
    });

    const responseData = await response.json();
    const TPH1Content = responseData.data;

    // Always clear old, already fetched data before new fetching process.
    if (tableBody) {
        tableBody.innerHTML = '';
    }

    TPH1Content.forEach(user => {
        const row = tableBody.insertRow();
        user.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

// This function initiates all data.
async function initiateAllData() {
    const response = await fetch("/initiate-data", {
        method: 'POST'
    });
    const responseData = await response.json();

    if (responseData.success) {
        const messageElement = document.getElementById('initiateResultMsg');
        messageElement.textContent = "All data are initiated successfully!";
        fetchTableData();
    } else {
        alert("Error initiating data!");
    }
}

// Inserts new records into TPH1.
async function insertTPH(event) {
    event.preventDefault();
    const seatNumberValue = document.getElementById('insertSeatNumber').value;
    const cidValue = document.getElementById('insertcid').value;
    const paymentmethodValue = document.getElementById('dropdown_paymentmethod').value;
    const paymentlocationValue = document.getElementById('dropdown_paymentlocation').value;
    const emailValue = document.getElementById('insertEmail').value;
    // const priceValue = document.getElementById('insertPrice').value;
    const seatlocationValue = document.getElementById('dropdown_seatlocation').value;

    const response = await fetch('/insert-TPH', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            seatnumber: seatNumberValue,
            cid: cidValue,
            paymentmethod: paymentmethodValue,
            paymentlocation: paymentlocationValue,
            email: emailValue,
            // price: priceValue,
            seatlocation: seatlocationValue
        })
    });

    const responseData = await response.json();
    const messageElement = document.getElementById('insertResultMsg');

    if (responseData.success) {
        messageElement.textContent = "Data inserted successfully!";
        fetchTableData();
    } else {
        messageElement.textContent = "Error inserting data!";
    }
}

// Inserts records from TPH1.
async function deleteFromTPH(event) {
    event.preventDefault();
    const seatNumberValue = document.getElementById('deleteSeatNumber').value;
    const cidValue = document.getElementById('deletecid').value;

    const response = await fetch('/delete-tickets', {
        method: 'POST', // Technically 'DELETE' but I delete data in the sense of updating the existing database.
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ seatnumber: seatNumberValue, cid: cidValue })
    });

    const responseData = await response.json();
    const messageElement = document.getElementById('deleteNameResultMsg');

    if (responseData.success) {
        messageElement.textContent = "Data deleted successfully!";
        fetchTableData();
    } else {
        messageElement.textContent = "Error deleting data!";
    }
}

async function retrieveSoldSeatNumbers(event) {
    event.preventDefault();
    const titleValue = document.getElementById('concertTitle').value;

    const response = await fetch('/get-unsold-seatInfo', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ title: titleValue })
    });

    const responseData = await response.json();
    const messageElement = document.getElementById('soldResultMsg');
    const list = document.getElementById('listOfUnsoldTickets');

    if (responseData.success && responseData.seatInfo) {
        messageElement.textContent = `Here are the sold ticket numbers for ${titleValue}:`;
        responseData.seatInfo.forEach(({ seatnumber, seatlocation }) => {
            const listItem = document.createElement('li');
            listItem.textContent = `Seat Number: ${seatnumber}, Location: ${seatlocation}`;
            list.appendChild(listItem);
        });
        fetchTableData();
    } else {
        messageElement.textContent = "Error retrieving data!";
    }
}

// Updates names in the demotable.
async function updateTPH1(event) {
    event.preventDefault();

    const seatNumberValue = document.getElementById('updateSeatNumber').value;
    const cidValue = document.getElementById('updatecid').value;
    let emailValue = document.getElementById('updateEmail').value;
    let paymentmethodValue = document.getElementById('update_dropdown_paymentmethod').value;
    let paymentlocationValue = document.getElementById('update_dropdown_paymentlocation').value;
    let seatlocationValue = document.getElementById('update_dropdown_seatlocation').value;

    const table = document.getElementById('TPH1');
    const rows = table.querySelectorAll('tbody tr');
    for (const row of rows) {
        const cells = row.getElementsByTagName('td');
        if (cells[0].textContent === seatNumberValue && cells[1].textContent === cidValue) {
            if (emailValue === "") {
                emailValue = cells[4].textContent;
            }
            if (paymentmethodValue === "default") {
                paymentmethodValue = cells[2].textContent;
            }
            if (paymentlocationValue === "default") {
                paymentlocationValue = cells[3].textContent;
            }
            if (seatlocationValue === "default") {
                seatlocationValue = cells[5].textContent;
            }
            break;
        }
    }

    const response = await fetch('/update-tickets', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            seatnumber: seatNumberValue,
            cid: cidValue,
            paymentmethod: paymentmethodValue,
            paymentlocation: paymentlocationValue,
            email: emailValue,
            seatlocation: seatlocationValue
        })
    });

    const messageElement = document.getElementById('updateTPH1ResultMsg');
    const responseData = await response.json();
    if (responseData.success) {
        messageElement.textContent = "Data updated successfully!";
        fetchTableData();
    } else {
        messageElement.textContent = "Error updating data!";
    }
}

// Counts rows in the demotable.
// Modify the function accordingly if using different aggregate functions or procedures.
async function countDemotable() {
    const response = await fetch("/count-demotable", {
        method: 'GET'
    });

    const responseData = await response.json();
    const messageElement = document.getElementById('countResultMsg');

    if (responseData.success) {
        const tupleCount = responseData.count;
        messageElement.textContent = `The number of tuples in demotable: ${tupleCount}`;
    } else {
        alert("Error in count demotable!");
    }
}


// ---------------------------------------------------------------
// Initializes the webpage functionalities.
// Add or remove event listeners based on the desired functionalities.
window.onload = function() {
    checkDbConnection();
    fetchTableData();
    document.getElementById("initiateAllData").addEventListener("click", initiateAllData);
    document.getElementById("insertTPH").addEventListener("submit", insertTPH);
    document.getElementById("deleteFromTPH").addEventListener("submit", deleteFromTPH);
    document.getElementById("soldFromTPH").addEventListener("submit", retrieveSoldSeatNumbers);
    document.getElementById("updataTPH1").addEventListener("submit", updateTPH1);
    document.getElementById("countDemotable").addEventListener("click", countDemotable);
};

// General function to refresh the displayed table data. 
// You can invoke this after any table-modifying operation to keep consistency.
function fetchTableData() {
    fetchAndDisplayUsers();
}

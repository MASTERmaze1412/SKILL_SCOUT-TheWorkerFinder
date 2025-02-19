const mongoose = require('mongoose');
const app = require('./app');
const connection = require('./config/db'); // Import the MongoDB connection function
const port = 8000;

// Connect to MongoDB before starting the server
connection().then(() => {
    console.log("MongoDB Connected Successfully");

    app.get('/', (req, res) => {
        res.send("Hello World!!!!");
    });

    app.listen(port, () => {
        console.log(`Server running on http://localhost:${port}`);
    });

}).catch((error) => {
    console.error("MongoDB Connection Failed:", error);
});

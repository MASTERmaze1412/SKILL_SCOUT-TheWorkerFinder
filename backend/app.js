const express = require('express');
const cors = require('cors');  // Add the CORS package
const userRouter = require('./routes/user.routers');
const workerRouter = require('./routes/worker.routes')
const bodyParser = require('body-parser');

const app = express();

// Enable CORS for all routes
app.use(cors());

// Parse JSON bodies
app.use(bodyParser.json());

// Routes
app.use('/', userRouter);
app.use('/',workerRouter);

module.exports = app;
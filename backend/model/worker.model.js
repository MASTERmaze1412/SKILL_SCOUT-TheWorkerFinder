const mongoose = require('mongoose');
const db = require('../config/db');
const { Schema } = mongoose;

const workerSchema = new Schema({
    firstname: { type: String, required: true },
    lastname: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    address: { type: String, required: true },
    phone: { type: String, required: true, unique: true },
    profession: { type: String, required: true },
    frontCitizenship: { type: String }, // Store image URL
    backCitizenship: { type: String}, // Store image URL
    document: { type: String }, // Store image URL (optional)
});

const WorkerModel = mongoose.model('Worker', workerSchema);
module.exports = WorkerModel;
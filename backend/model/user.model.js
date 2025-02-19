const mongoose = require('mongoose');
const bcrypt = require("bcrypt");
const db = require('../config/db');
const { Schema } = mongoose;

const userSchema = new Schema({
    name: {
        type: String,
        required: true,
        trim: true,
        minlength: 2,
        maxlength: 20,
        match: /^[A-Za-z\s]+$/, // Allows only letters and spaces
    },
    email: {
        type: String,
        lowercase: true,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true,
        minlength: 8,
    },
    phone: {
        type: String,
        required: true,
        unique: true,
    },
    profileImage: {
        type: String,
        default: "https://via.placeholder.com/150", // Default profile picture
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
    updatedAt: {
        type: Date,
        default: Date.now,
    },
});

// Hash the password before saving the user
userSchema.pre('save', async function (next) {
    try {
        const user = this;
        if (user.isModified('password')) {
            const salt = await bcrypt.genSalt(10);
            const hashpass = await bcrypt.hash(user.password, salt);
            user.password = hashpass;
        }
        next();
    } catch (error) {
        next(error);
    }
});

// Method to compare passwords
userSchema.methods.comparePassword = async function (userPassword) {
    try {
        const isMatch = await bcrypt.compare(userPassword, this.password);
        return isMatch; // Return true or false
    } catch (error) {
        throw error;
    }
};

// Update the 'updatedAt' field before saving
userSchema.pre('save', function (next) {
    this.updatedAt = Date.now();
    next();
});

const UserModel = mongoose.model('User', userSchema);
module.exports = UserModel;
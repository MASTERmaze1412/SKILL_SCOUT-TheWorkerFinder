const { google } = require('googleapis');
const path = require('path');
const fs = require('fs');
require('dotenv').config();

// Google Drive Setup using environment variables
const CLIENT_ID = process.env.GOOGLE_CLIENT_ID;
const CLIENT_SECRET = process.env.GOOGLE_CLIENT_SECRET;
const REDIRECT_URI = process.env.GOOGLE_REDIRECT_URI;
const REFRESH_TOKEN = process.env.GOOGLE_REFRESH_TOKEN;

const oauth2Client = new google.auth.OAuth2(
    CLIENT_ID,
    CLIENT_SECRET,
    REDIRECT_URI
);

oauth2Client.setCredentials({ refresh_token: REFRESH_TOKEN });

const drive = google.drive({
    version: 'v3',
    auth: oauth2Client
});

// Function to handle image upload
const uploadImage = async (file) => {
    try {
        const filePath = file.path;

        // Upload file to Google Drive
        const response = await drive.files.create({
            requestBody: {
                name: file.originalname,
                mimeType: file.mimetype
            },
            media: {
                mimeType: file.mimetype,
                body: fs.createReadStream(filePath)
            }
        });

        // Make the file publicly accessible
        await drive.permissions.create({
            fileId: response.data.id,
            requestBody: {
                role: "reader",
                type: "anyone"
            }
        });

        // Get file's public URL
        const fileUrl = `https://drive.google.com/uc?id=${response.data.id}`;

        // Delete the file from the server after upload
        fs.unlinkSync(filePath);

        return fileUrl;
    } catch (error) {
        console.error('Error uploading file:', error);
        throw error;
    }
};

module.exports = { uploadImage };
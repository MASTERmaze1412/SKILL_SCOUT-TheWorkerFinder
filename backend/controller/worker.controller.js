const WorkerService = require('../services/worker.services');
const ImageUpload = require('../imageupload');

exports.registerWorker = async (req, res) => {
    try {
        const { firstname, lastname, email, address, phone, profession } = req.body;

        // Log the files received
        console.log('Files received:', req.files);

        // Check if files exist and upload them
        const frontCitizenship = req.files && req.files['frontCitizenship']
            ? await ImageUpload.uploadImage(req.files['frontCitizenship'][0])
            : null;

        const backCitizenship = req.files && req.files['backCitizenship']
            ? await ImageUpload.uploadImage(req.files['backCitizenship'][0])
            : null;

        const document = req.files && req.files['document']
            ? await ImageUpload.uploadImage(req.files['document'][0])
            : null;

        // Log the uploaded file URLs
        console.log('Front Citizenship URL:', frontCitizenship);
        console.log('Back Citizenship URL:', backCitizenship);
        console.log('Document URL:', document);

        // Call the service to save the worker data in the database
        await WorkerService.registerWorker(
            firstname,
            lastname,
            email,
            address,
            phone,
            profession,
            frontCitizenship,
            backCitizenship,
            document
        );

        // Respond with success message
        res.status(200).json({ status: true, message: "Worker Registered Successfully" });
    } catch (err) {
        console.error('Error in registerWorker:', err);
        res.status(500).json({ status: false, message: "Registration failed", error: err.message });
    }
};
const mongoose = require('mongoose');
//check connections
const connection = async () => {
    try {
        await mongoose.connect(
            "mongodb+srv://skill_scout:kHOtqGmNXpfWrFLq@cluster0.cylqet5.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0",
            {
                //useNewUrlParser: true,
                //useUnifiedTopology: true
            }
        );

        console.log("✅ MongoDB Connected Successfully");
    } catch (error) {
        console.error("❌ MongoDB Connection Failed:", error.message);
        process.exit(1);
    }
};




module.exports = connection;

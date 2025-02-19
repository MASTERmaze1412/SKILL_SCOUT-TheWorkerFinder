const UserService = require("../services/user.services");

exports.register = async (req, res, next) => {
    try {
        const { name, email, password, phone } = req.body;
        const successRes = await UserService.registerUser(name, email, password, phone);
        res.json({ status: true, success: "User Registered Successfully", userId: successRes._id });
    } catch (err) {
        next(err); // Pass error to Express error handler
    }
};

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        const user = await UserService.checkuser(email);

        if (!user) {
            return res.status(404).json({ status: false, message: "User Doesn't Exist" });
        }

        const isMatch = await user.comparePassword(password);
        if (!isMatch) {
            return res.status(401).json({ status: false, message: "Invalid Password" });
        }

        const tokenData = { _id: user._id, email: user.email };
        const token = await UserService.generateToken(tokenData, "secretkey", '1h');

        // ✅ Include all required fields in the response
        res.status(200).json({
            status: true,
            token: token,
            userId: user._id,
            name: user.name,
            email: user.email,
            phone: user.phone,
            profileImage: user.profileImage || ""  // Optional field for profile picture
        });
    } catch (err) {
        next(err);
    }
};


exports.updateUser = async (req, res, next) => {
    try {
        const userId = req.params.userId;
        const { name, email, phone } = req.body;

        const updatedUser = await UserService.updateUser(userId, { name, email, phone });
        res.json({ status: true, success: "User Updated Successfully", user: updatedUser });
    } catch (err) {
        next(err);
    }
};

exports.uploadProfileImage = async (req, res, next) => {
    try {
        const userId = req.params.userId;
        const fileUrl = req.fileUrl; // Assuming the file URL is passed from the middleware

        const updatedUser = await UserService.updateUser(userId, { profileImage: fileUrl });
        res.json({ status: true, success: "Profile Image Updated Successfully", user: updatedUser });
    } catch (err) {
        next(err);
    }
};
require("dotenv").config();
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

exports.sendOtpEmail = functions.https.onRequest(async (req, res) => {
  try {
    console.log("Nhận yêu cầu gửi OTP:", req.body);
    
    const { email } = req.body;
    if (!email) {
      console.error("Lỗi: Không có email trong request.");
      return res.status(400).json({ success: false, message: "Email is required" });
    }

    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    console.log("OTP tạo ra:", otp);

    const mailOptions = {
      from: "nguyenhoanganh.52200067@gmail.com",
      to: email,
      subject: "Ecommerce App OTP Verification",
      text: `Mã OTP của bạn là: ${otp}. Mã này sẽ hết hạn sau 1 phút.`,
    };

    const info = await transporter.sendMail(mailOptions);
    console.log("Email đã gửi thành công:", info.response);

    return res.status(200).json({ success: true, otp });
  } catch (error) {
    console.error("Lỗi khi gửi email:", error);
    return res.status(500).json({ success: false, message: "Không thể gửi OTP", error: error.toString() });
  }
});
    
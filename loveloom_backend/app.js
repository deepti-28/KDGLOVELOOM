const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const multer = require('multer');
require('dotenv').config();

const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/user');
const galleryRoutes = require('./routes/gallery');

const app = express();

// Middleware to parse JSON requests
app.use(express.json());

// Enable CORS to allow frontend access
app.use(cors());

// Configure multer for general file uploads in uploads directory
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/'); // Root uploads folder
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + '-' + file.originalname);
  }
});
const upload = multer({ storage: storage });

// Serve uploaded files statically from /uploads endpoint
app.use('/uploads', express.static('uploads'));

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error('MongoDB connection error:', err));

// Use modular route handlers
app.use('/api/auth', authRoutes);

// Note: If specific routes require multer middleware, apply inside those route files
app.use('/api/user', userRoutes);

app.use('/api/gallery', galleryRoutes);

// Test root route
app.get('/', (req, res) => {
  res.send('LoveLoom API is running');
});

// Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));

// Export upload middleware if needed by other modules
module.exports = { upload };

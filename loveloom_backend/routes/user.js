const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const User = require('../models/User');
const jwt = require('jsonwebtoken');

// Multer configuration to store uploaded profile images in 'uploads/profile_photos'
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/profile_photos/');
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  }
});
const upload = multer({ storage });

// JWT authentication middleware
const authenticate = (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader)
    return res.status(401).json({ error: 'Authorization header missing' });

  const token = authHeader.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'Token missing' });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.id;
    next();
  } catch (err) {
    return res.status(401).json({ error: 'Invalid token' });
  }
};

// GET /api/user/profile - Retrieve user profile (excluding password)
router.get('/profile', authenticate, async (req, res) => {
  try {
    const user = await User.findById(req.userId).select('-password');
    if (!user) return res.status(404).json({ error: 'User not found' });

    res.json(user);
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// PATCH /api/user/profile - Partial update user profile fields
router.patch('/profile', authenticate, async (req, res) => {
  try {
    const allowedFields = [
      'name',
      'location',
      'profileImagePath',
      'dob',
      'username',
      'galleryImages',
      'notes'
    ];
    const updates = {};

    allowedFields.forEach(field => {
      if (req.body[field] !== undefined) {
        updates[field] = req.body[field];
      }
    });

    if (Object.keys(updates).length === 0) {
      return res.status(400).json({ error: 'No valid fields provided for update' });
    }

    const updatedUser = await User.findByIdAndUpdate(
      req.userId,
      updates,
      { new: true }
    ).select('-password');

    if (!updatedUser) return res.status(404).json({ error: 'User not found' });

    console.log('User profile updated:', updatedUser);
    res.json({ message: 'Profile updated successfully', user: updatedUser });
  } catch (error) {
    console.error('Profile update error:', error);
    res.status(500).json({ error: 'Server error during update' });
  }
});

// POST /api/user/uploadProfileImage - Upload profile image and update user document
router.post(
  '/uploadProfileImage',
  authenticate,
  upload.single('profileImage'),
  async (req, res) => {
    if (!req.file) return res.status(400).json({ error: 'No file uploaded' });

    const imageUrl = `/uploads/profile_photos/${req.file.filename}`;

    try {
      const updatedUser = await User.findByIdAndUpdate(
        req.userId,
        { profileImagePath: imageUrl },
        { new: true }
      ).select('-password');

      if (!updatedUser) return res.status(404).json({ error: 'User not found' });

      console.log(
        `Profile image uploaded and updated for user ${req.userId}: ${imageUrl}`
      );

      res.json({ message: 'Image uploaded successfully', imageUrl });
    } catch (err) {
      console.error('Error updating user image path:', err);
      res.status(500).json({ error: 'Server error during image update' });
    }
  }
);

module.exports = router;

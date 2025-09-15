const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    trim: true,
    required: [true, 'Name is required'],
  },
  username: {
    type: String,
    trim: true,
    unique: true,
    sparse: true, // allows multiple docs without username
    // Add index to speed unique checks
    index: true,
  },
  email: {
    type: String,
    unique: true,
    required: [true, 'Email is required'],
    trim: true,
    lowercase: true,
  },
  gender: {
    type: String,
    enum: ['male', 'female', 'other'], // values must match frontend input (lowercase)
    default: 'other',
    required: [true, 'Gender is required'],
  },
  dob: {
    type: Date,
    required: [true, 'Date of birth is required'],
  },
  password: {
    type: String,
    required: [true, 'Password is required'],
  },
  location: {
    type: String,
    trim: true,
  },
  about: {
    type: String,
    trim: true,
  },
  profileImagePath: {
    type: String,
    default: null,
  },
  galleryImages: {
    type: [String],
    default: [],
  },
  notes: {
    type: [String],
    default: [],
  },
}, {
  timestamps: true,
});

module.exports = mongoose.model('User', userSchema);

const mongoose = require('mongoose');
const gallerySchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  imageUrl: String,
  uploadedAt: { type: Date, default: Date.now },
});
module.exports = mongoose.model('Gallery', gallerySchema);

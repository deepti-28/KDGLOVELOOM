const mongoose = require('mongoose');

const noteSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  text: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
});

const placeSchema = new mongoose.Schema({
  name: { type: String, required: true, trim: true },
  address: { type: String, trim: true },
  location: { type: String, trim: true }, // e.g. "New Delhi"
  likes: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }], // users who liked the place
  notes: [noteSchema],
}, {
  timestamps: true,
});

module.exports = mongoose.model('Place', placeSchema);

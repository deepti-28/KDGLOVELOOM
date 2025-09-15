const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth'); // Your auth middleware to get user info
const Place = require('../models/Place');

// Get list of places (optional: add pagination/filtering)
router.get('/', async (req, res) => {
  try {
    const places = await Place.find().select('name address location likes notes').lean();
    res.json(places);
  } catch (error) {
    console.error('Error fetching places:', error);
    res.status(500).json({ message: 'Server error fetching places' });
  }
});

// Get place details by ID including notes with user info populated
router.get('/:id', async (req, res) => {
  try {
    const place = await Place.findById(req.params.id)
      .populate('notes.user', 'name profileImagePath')
      .populate('likes', 'name')
      .lean();
    if (!place) return res.status(404).json({ message: 'Place not found' });
    res.json(place);
  } catch (error) {
    console.error('Error fetching place:', error);
    res.status(500).json({ message: 'Server error fetching place' });
  }
});

// Toggle like/unlike place (requires auth)
router.post('/:id/like', auth, async (req, res) => {
  try {
    const place = await Place.findById(req.params.id);
    if (!place) return res.status(404).json({ message: 'Place not found' });

    const userId = req.user.id;
    const likedIndex = place.likes.findIndex(id => id.toString() === userId);

    if (likedIndex === -1) {
      place.likes.push(userId);
    } else {
      place.likes.splice(likedIndex, 1);
    }

    await place.save();
    res.json({ likesCount: place.likes.length, liked: likedIndex === -1 });
  } catch (error) {
    console.error('Error toggling like:', error);
    res.status(500).json({ message: 'Server error toggling like' });
  }
});

// Get notes for a place
router.get('/:id/notes', async (req, res) => {
  try {
    const place = await Place.findById(req.params.id).populate('notes.user', 'name profileImagePath');
    if (!place) return res.status(404).json({ message: 'Place not found' });
    res.json(place.notes);
  } catch (error) {
    console.error('Error fetching notes:', error);
    res.status(500).json({ message: 'Server error fetching notes' });
  }
});

// Add a new note to a place (requires auth)
router.post('/:id/notes', auth, async (req, res) => {
  try {
    const { text } = req.body;
    if (!text || text.trim() === '') return res.status(400).json({ message: 'Note text required' });

    const place = await Place.findById(req.params.id);
    if (!place) return res.status(404).json({ message: 'Place not found' });

    const note = {
      user: req.user.id,
      text: text.trim(),
      createdAt: new Date(),
    };

    place.notes.push(note);
    await place.save();

    // Optionally populate user details before returning
    const savedNote = place.notes[place.notes.length - 1];
    await savedNote.populate('user', 'name profileImagePath');

    res.status(201).json(savedNote);
  } catch (error) {
    console.error('Error adding note:', error);
    res.status(500).json({ message: 'Server error adding note' });
  }
});

module.exports = router;

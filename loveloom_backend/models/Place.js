const express = require('express');
const router = express.Router();
const auth = require('../middlewares/auth');
const Place = require('../models/Place');

const isObjectId = (id) => /^[0-9a-fA-F]{24}$/.test(id);

// Find a place by Mongo _id or by external id (e.g. OpenStreetMap id)
async function findPlace(id) {
  if (isObjectId(id)) return Place.findById(id);
  return Place.findOne({ externalId: id });
}

// Find a place, or create it on first use (for non-Mongo ids)
async function findOrCreatePlace(id) {
  const existing = await findPlace(id);
  if (existing || isObjectId(id)) return existing;
  return Place.create({
    name: `Place ${id}`,
    address: '',
    location: '',
    externalId: id,
  });
}

// Get list of places
router.get('/', async (req, res) => {
  try {
    const places = await Place.find().select('name address location likes notes').lean();
    res.json(places);
  } catch (error) {
    console.error('Error fetching places:', error);
    res.status(500).json({ message: 'Server error fetching places' });
  }
});

// Get place details
router.get('/:id', async (req, res) => {
  try {
    const place = await findPlace(req.params.id);
    if (!place) return res.status(404).json({ message: 'Place not found' });
    await place.populate([
      { path: 'notes.user', select: 'name profileImagePath' },
      { path: 'likes', select: 'name' },
    ]);
    res.json(place);
  } catch (error) {
    console.error('Error fetching place:', error);
    res.status(500).json({ message: 'Server error fetching place' });
  }
});

// Toggle like/unlike (requires auth)
router.post('/:id/like', auth, async (req, res) => {
  try {
    const place = await findOrCreatePlace(req.params.id);
    if (!place) return res.status(404).json({ message: 'Place not found' });

    const userId = req.user.id;
    const likedIndex = place.likes.findIndex((id) => id.toString() === userId);

    if (likedIndex === -1) place.likes.push(userId);
    else place.likes.splice(likedIndex, 1);

    await place.save();
    res.json({ likesCount: place.likes.length, liked: likedIndex === -1 });
  } catch (error) {
    console.error('Error toggling like:', error);
    res.status(500).json({ message: 'Server error toggling like' });
  }
});

// Get notes (empty list if the place has none yet)
router.get('/:id/notes', async (req, res) => {
  try {
    const place = await findPlace(req.params.id);
    if (!place) return res.json([]);
    await place.populate('notes.user', 'name profileImagePath');
    res.json(place.notes);
  } catch (error) {
    console.error('Error fetching notes:', error);
    res.status(500).json({ message: 'Server error fetching notes' });
  }
});

// Add a note (requires auth)
router.post('/:id/notes', auth, async (req, res) => {
  try {
    const { text } = req.body;
    if (!text || text.trim() === '') {
      return res.status(400).json({ message: 'Note text required' });
    }

    const place = await findOrCreatePlace(req.params.id);
    if (!place) return res.status(404).json({ message: 'Place not found' });

    place.notes.push({
      user: req.user.id,
      text: text.trim(),
      createdAt: new Date(),
    });
    await place.save();

    await place.populate('notes.user', 'name profileImagePath');
    res.status(201).json(place.notes[place.notes.length - 1]);
  } catch (error) {
    console.error('Error adding note:', error);
    res.status(500).json({ message: 'Server error adding note' });
  }
});

module.exports = router;
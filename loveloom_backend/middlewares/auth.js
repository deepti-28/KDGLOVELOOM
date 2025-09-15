const jwt = require('jsonwebtoken');

module.exports = (req, res, next) => {
  const authHeader = req.header('Authorization');
  if (!authHeader) return res.status(401).json({ message: 'Access denied: No token provided' });

  const token = authHeader.replace('Bearer ', '');

  if (!token) return res.status(401).json({ message: 'Access denied: Invalid token format' });

  try {
    const verified = jwt.verify(token, process.env.JWT_SECRET);
    req.user = verified;
    next();
  } catch (err) {
    return res.status(401).json({ message: 'Invalid token' });
  }
};

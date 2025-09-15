import 'package:flutter/material.dart';
import 'services/api_service.dart'; // Update with your actual relative or package path
import 'note_dialog.dart'; // Update accordingly

class CafesPage extends StatefulWidget {
  final String placeId;
  final String imageUrl;
  final String cafeName;
  final String address;
  final String distance;
  final String reviewText;
  final String reviewDate;
  final String reviewerName;
  final String reviewerLocation;

  const CafesPage({
    Key? key,
    required this.placeId,
    required this.imageUrl,
    required this.cafeName,
    required this.address,
    required this.distance,
    required this.reviewText,
    required this.reviewDate,
    required this.reviewerName,
    required this.reviewerLocation,
  }) : super(key: key);

  @override
  _CafesPageState createState() => _CafesPageState();
}

class _CafesPageState extends State<CafesPage> {
  final ApiService _apiService = ApiService();

  int likesCount = 0;
  bool isLikedByUser = false;
  List<dynamic> notes = [];
  bool isLoadingNotes = false;
  bool isLoadingLikes = false;

  @override
  void initState() {
    super.initState();
    _fetchPlaceDetails();
    _fetchNotes();
  }

  Future<void> _fetchPlaceDetails() async {
    setState(() => isLoadingLikes = true);
    try {
      final placeData = await _apiService.getPlaceDetails(widget.placeId);
      setState(() {
        likesCount = (placeData['likes'] as List<dynamic>).length;
        // TODO: Detect if current user liked the place
        isLikedByUser = false;
      });
    } catch (_) {
      // Handle error or show message
    } finally {
      setState(() => isLoadingLikes = false);
    }
  }

  Future<void> _fetchNotes() async {
    setState(() => isLoadingNotes = true);
    try {
      final fetchedNotes = await _apiService.getPlaceNotes(widget.placeId);
      setState(() {
        notes = fetchedNotes;
      });
    } catch (_) {
      // Handle error or show message
    } finally {
      setState(() => isLoadingNotes = false);
    }
  }

  Future<void> _toggleLike() async {
    setState(() => isLoadingLikes = true);
    bool success = await _apiService.toggleLikePlace(widget.placeId);
    if (success) {
      setState(() {
        if (isLikedByUser) {
          likesCount = (likesCount > 0) ? likesCount - 1 : 0;
          isLikedByUser = false;
        } else {
          likesCount += 1;
          isLikedByUser = true;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update like.')));
    }
    setState(() => isLoadingLikes = false);
  }

  Future<void> _openAddNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => NoteDialogPage(placeId: widget.placeId)),
    );
    if (result == true) {
      _fetchNotes();
    }
  }

  void _showNotesDialog() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        if (isLoadingNotes) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (notes.isEmpty) {
          return SizedBox(
            height: 200,
            child: Center(child: Text("No notes yet. Be the first to add one!")),
          );
        }
        return SizedBox(
          height: 400,
          child: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              final user = note['user'] ?? {};
              final userName = user['name'] ?? 'Anonymous';
              final noteText = note['text'] ?? '';
              final createdAt = note['createdAt'] ?? '';

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user['profileImagePath'] != null
                      ? NetworkImage(user['profileImagePath'])
                      : null,
                  child: user['profileImagePath'] == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(userName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(noteText),
                    const SizedBox(height: 4),
                    Text(
                      createdAt.split('T').first,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNoteItem(dynamic note) {
    final user = note['user'] ?? {};
    final userName = user['name'] ?? 'Anonymous';
    final noteText = note['text'] ?? '';
    final createdAt = note['createdAt'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: (user['profileImagePath'] != null)
                ? NetworkImage(user['profileImagePath'])
                : null,
            child: user['profileImagePath'] == null
                ? const Icon(Icons.person)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    noteText,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  createdAt.split('T').first,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFF45B62);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: pink, size: 26),
                  onPressed: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _toggleLike,
                      child: Row(
                        children: [
                          Icon(
                            isLikedByUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isLikedByUser ? pink : Colors.grey[400],
                            size: 26,
                          ),
                          const SizedBox(width: 5),
                          if (isLoadingLikes)
                            const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: pink,
                                ))
                          else
                            Text(
                              likesCount.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => _fetchNotes().then((_) => _showNotesDialog()),
                      child: Row(
                        children: [
                          const Icon(Icons.mode_comment_outlined,
                              color: Colors.grey, size: 26),
                          const SizedBox(width: 5),
                          Text(notes.length.toString(),
                              style: const TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: _openAddNote,
                      child: const Icon(Icons.edit_note,
                          color: Colors.grey, size: 26),
                    ),
                    const SizedBox(width: 10),
                  ],
                )
              ],
            ),
          ),

          // Main card (image, titles, etc.)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: Image.network(
                    widget.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        pink.withOpacity(0.65),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  top: 15,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: pink,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  right: 15,
                  top: 15,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.87),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Text(
                      widget.distance,
                      style: const TextStyle(
                          color: pink,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 64,
                  child: Center(
                    child: Text(
                      widget.cafeName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          letterSpacing: 0.1),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 41,
                  child: Center(
                    child: Text(
                      widget.address.toUpperCase(),
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.93),
                          fontSize: 13.3,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Comments section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'What people say about the place',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'Nunito',
              ),
            ),
          ),
          const SizedBox(height: 8),

          isLoadingNotes
              ? const Center(child: CircularProgressIndicator())
              : notes.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "No comments yet. Be the first to add a note!",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: notes.length,
                      itemBuilder: (context, index) =>
                          _buildNoteItem(notes[index]),
                    ),

          const SizedBox(height: 24),
        ],
      ),

      bottomNavigationBar: Container(
        height: 62,
        decoration: BoxDecoration(
          color: pink,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home,
                  color: Colors.white, size: 26),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/dashboard', (route) => false);
              },
            ),
            IconButton(
              icon: const Icon(Icons.explore,
                  color: Colors.white, size: 26),
              onPressed: () {
                Navigator.pushNamed(context, '/openstreetmap_page');
              },
            ),
            IconButton(
              icon: const Icon(Icons.search,
                  color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pushNamed(context, '/explore');
              },
            ),
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline,
                  color: Colors.white, size: 26),
              onPressed: () {
                Navigator.pushNamed(context, '/message');
              },
            ),
            IconButton(
              icon: const Icon(Icons.person,
                  color: Colors.white, size: 26),
              onPressed: () {
                Navigator.pushNamed(context, '/userprofile');
              },
            ),
          ],
        ),
      ),
    );
  }
}

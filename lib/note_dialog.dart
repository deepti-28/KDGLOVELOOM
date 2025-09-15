import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'services/api_service.dart'; // Make sure this path is correct based on your project structure

class NoteDialogPage extends StatefulWidget {
  final String placeId;

  const NoteDialogPage({Key? key, required this.placeId}) : super(key: key);

  @override
  State<NoteDialogPage> createState() => _NoteDialogPageState();
}

class _NoteDialogPageState extends State<NoteDialogPage> {
  final ApiService _apiService = ApiService();

  final TextEditingController _controller = TextEditingController();
  File? _attachment;
  List<Map<String, dynamic>> _notes = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    setState(() => _isLoading = true);
    try {
      final notesData = await _apiService.getPlaceNotes(widget.placeId);
      setState(() {
        _notes = List<Map<String, dynamic>>.from(notesData);
      });
    } catch (e) {
      // Handle error gracefully, optionally display a snackbar or similar
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSend() async {
    final noteText = _controller.text.trim();
    if (noteText.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final success = await _apiService.addPlaceNote(widget.placeId, noteText);
      if (success) {
        setState(() {
          _notes.insert(0, {
            'text': noteText,
            'user': {
              'name': 'You', // You can update this with logged-in user's info
              'profileImagePath': null,
            },
            'createdAt': DateTime.now().toIso8601String(),
          });
          _controller.clear();
          _attachment = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit note. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting note.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAttachment() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _attachment = File(pickedFile.path));
      // TODO: Implement attachment upload if needed
    }
  }

  void _handleRecord() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mic button pressed (feature coming soon)!')),
    );
  }

  Widget _buildNoteItem(Map<String, dynamic> note) {
    final user = note['user'] ?? {};
    final userName = user['name'] ?? 'Anonymous';
    final noteText = note['text'] ?? '';
    final createdAt = DateTime.tryParse(note['createdAt'] ?? '');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: Text(noteText, style: const TextStyle(fontSize: 16)),
            ),
            if (createdAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${createdAt.day}/${createdAt.month}/${createdAt.year}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_notes.isEmpty) {
      return const Center(
        child: Text(
          'No notes yet.\nBe the first to add one!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.only(bottom: 80, top: 12),
      itemCount: _notes.length,
      itemBuilder: (context, index) => _buildNoteItem(_notes[index]),
    );
  }

  Widget _buildInputBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF5A6A6), width: 1.1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Write a note...',
                border: InputBorder.none,
              ),
              minLines: 1,
              maxLines: 5,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.attach_file, color: Color(0xFFF5A6A6)),
            onPressed: _pickAttachment,
          ),
          IconButton(
            icon: const Icon(Icons.mic, color: Color(0xFFF5A6A6)),
            onPressed: _handleRecord,
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFFF5A6A6)),
            onPressed: _handleSend,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFF5A6A6),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF5A6A6).withOpacity(0.11),
            blurRadius: 18,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, size: 28, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
          IconButton(
            icon: const Icon(Icons.explore, size: 28, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/openstreetmap_search_page');
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, size: 32, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/explore');
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat, size: 28, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/message');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, size: 28, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/userprofile');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE6E6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF5A6A6)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Write a note',
          style: TextStyle(
            color: Color(0xFF61291E),
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Nunito',
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildNoteList(),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildInputBar(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
}

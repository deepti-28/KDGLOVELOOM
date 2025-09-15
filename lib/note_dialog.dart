import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class NoteDialogPage extends StatefulWidget {
  const NoteDialogPage({Key? key}) : super(key: key);

  @override
  State<NoteDialogPage> createState() => _NoteDialogPageState();
}

class _NoteDialogPageState extends State<NoteDialogPage> {
  TextEditingController _controller = TextEditingController();
  File? _attachment;
  final List<String> _messages = [];

  Future<void> _pickAttachment() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _attachment = File(pickedFile.path);
      });
    }
  }

  void _handleSend() {
    final note = _controller.text.trim();
    if (note.isEmpty) return;

    setState(() {
      _messages.insert(0, note);
      _controller.clear();
      _attachment = null; // clear attachment on send if any
    });

    // Optionally scroll the ListView to top or bottom here if needed.
  }

  void _handleRecord() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mic button pressed (feature coming soon)!')),
    );
  }

  Widget buildMessageList() {
    return _messages.isEmpty
        ? const Center(
      child: Text(
        'No messages yet.\nWrite a note to publish...',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    )
        : ListView.builder(
      reverse: true,
      padding: EdgeInsets.only(bottom: 80, top: 12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF45B62),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Text(
                _messages[index],
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildMessageBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF45B62), width: 1.1),
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
            icon: const Icon(Icons.attach_file, color: Color(0xFFF45B62)),
            onPressed: _pickAttachment,
          ),
          IconButton(
            icon: const Icon(Icons.mic, color: Color(0xFFF45B62)),
            onPressed: _handleRecord,
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFFF45B62)),
            onPressed: _handleSend,
          ),
        ],
      ),
    );
  }

  Widget buildBottomNavBar() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFF45B62),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF45B62).withOpacity(0.11),
            blurRadius: 18,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, size: 26, color: Colors.white),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (r) => false);
            },
          ),
          IconButton(
            icon: const Icon(Icons.explore, size: 26, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/openstreetmap_search_page');
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/explore');
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, size: 26, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/message');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, size: 26, color: Colors.white),
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
      backgroundColor: const Color(0xFFFFE4EF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF45B62)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Write a note to publish...",
          style: TextStyle(
            color: Color(0xFF612822),
            fontWeight: FontWeight.w400,
            fontSize: 18,
            fontFamily: 'Nunito',
          ),
        ),
      ),
      body: buildMessageList(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildMessageBar(),
          buildBottomNavBar(),
        ],
      ),
    );
  }
}

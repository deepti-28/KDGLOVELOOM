import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'services/api_service.dart';

class EditProfilePage extends StatefulWidget {
  final String? name;
  final String? dob;
  final String? initialImage;
  final String? initialLocation;
  final List<String>? initialGalleryImages;
  final List<String>? initialNotes;
  final String? initialName;
  final String? initialDob;

  const EditProfilePage({
    Key? key,
    this.name,
    this.dob,
    this.initialImage,
    this.initialLocation,
    this.initialGalleryImages,
    this.initialNotes,
    this.initialName,
    this.initialDob,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final Color pink = const Color(0xFFF43045);

  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _locationController;

  String? imagePath;
  List<String> galleryImages = [];
  List<String> notes = [];

  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();

  bool _saving = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(text: widget.name ?? widget.initialName ?? '');
    _dobController =
        TextEditingController(text: widget.dob ?? widget.initialDob ?? '');
    _locationController =
        TextEditingController(text: widget.initialLocation ?? '');
    imagePath = widget.initialImage;
    galleryImages =
        widget.initialGalleryImages != null ? List.from(widget.initialGalleryImages!) : [];
    notes = widget.initialNotes != null ? List.from(widget.initialNotes!) : [];
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _pickGalleryImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        galleryImages.add(pickedFile.path);
      });
    }
  }

  void _addNote() {
    String newNote = '';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Add Note", style: TextStyle(color: pink)),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: "Write your note here"),
          onChanged: (val) => newNote = val,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (newNote.trim().isNotEmpty) {
                setState(() {
                  notes.insert(0, newNote.trim());
                });
              }
              Navigator.of(ctx).pop();
            },
            child: const Text("Add", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _profileAvatar() {
    return Container(
      width: 124,
      height: 124,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: pink, width: 4),
        color: pink.withOpacity(0.13),
      ),
      child: GestureDetector(
        onTap: _pickImageFromGallery,
        child: CircleAvatar(
          radius: 56,
          backgroundColor: Colors.white,
          backgroundImage: imagePath != null ? FileImage(File(imagePath!)) : null,
          child:
              imagePath == null ? Icon(Icons.person, size: 72, color: Colors.grey[400]) : null,
        ),
      ),
    );
  }

  Widget _inputSection(
      {required String label,
      required TextEditingController controller,
      bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w500)),
          TextField(
            controller: controller,
            style: TextStyle(
                fontSize: 17.5,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                color: Colors.black87),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 3),
            ),
          ),
          const Divider(thickness: 1.05),
        ],
      ),
    );
  }

  Widget _gallerySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Gallery",
              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          SizedBox(
            height: 72,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: galleryImages.length + 1,
              itemBuilder: (ctx, index) {
                if (index < galleryImages.length) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.file(
                        File(galleryImages[index]),
                        width: 62,
                        height: 62,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: _pickGalleryImage,
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: pink.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: pink, width: 2),
                    ),
                    child: const Icon(Icons.add, color: Colors.redAccent, size: 30),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _notesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("Notes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
              IconButton(icon: Icon(Icons.add_circle_outline, color: pink), onPressed: _addNote),
            ],
          ),
          if (notes.isEmpty)
            const Text(
              "No notes added yet.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ...notes
              .map((e) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.note, size: 18),
                        const SizedBox(width: 8),
                        Flexible(child: Text(e)),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Future<void> _saveProfile() async {
    setState(() {
      _saving = true;
      _errorMsg = null;
    });

    String? profileImageUrl = imagePath;
    if (imagePath != null && !imagePath!.startsWith('http')) {
      // Upload local image
      final url = await _apiService.uploadProfileImage(File(imagePath!));
      if (url != null) profileImageUrl = url;
    }

    bool success = await _apiService.updateProfile(
      name: _nameController.text.trim(),
      dob: _dobController.text.trim(),
      location: _locationController.text.trim(),
      profileImagePath: profileImageUrl,
      galleryImages: galleryImages,
      notes: notes,
    );

    setState(() {
      _saving = false;
      if (success) {
        Navigator.pop(context, {
          'name': _nameController.text.trim(),
          'dob': _dobController.text.trim(),
          'location': _locationController.text.trim(),
          'image': profileImageUrl,
          'galleryImages': galleryImages,
          'notes': notes,
        });
      } else {
        _errorMsg = "Failed to save profile. Please try again.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomBar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: pink),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text('Edit Profile',
              style: const TextStyle(
                  color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
              onPressed: _saving ? null : _saveProfile,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.redAccent,
                      ),
                    )
                  : Text("Save",
                      style: TextStyle(color: pink, fontWeight: FontWeight.w600, fontSize: 18)),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          children: [
            if (_errorMsg != null)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(_errorMsg!,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center),
              ),
            const SizedBox(height: 10),
            Center(child: Column(children: [_profileAvatar(), _editPhotoText()])),
            _inputSection(label: "Name", controller: _nameController, bold: true),
            _inputSection(label: "Date of birth", controller: _dobController, bold: true),
            _inputSection(label: "Location", controller: _locationController),
            _gallerySection(),
            _notesSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _editPhotoText() => GestureDetector(
        onTap: _pickImageFromGallery,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            "Edit Profile Photo",
            style: TextStyle(
              color: pink,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      );

  Widget _bottomBar() => Container(
        height: 62,
        decoration: BoxDecoration(
          color: pink,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32)),
          boxShadow: [BoxShadow(color: pink.withOpacity(0.1), blurRadius: 8)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () => Navigator.pop(context)),
            IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
            IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: _pickGalleryImage),
            IconButton(icon: const Icon(Icons.message, color: Colors.white), onPressed: () {}),
            IconButton(icon: const Icon(Icons.person, color: Colors.white), onPressed: () {}),
          ],
        ),
      );
}

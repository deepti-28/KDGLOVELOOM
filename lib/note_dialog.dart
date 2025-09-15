import 'package:flutter/material.dart';

class NoteDialog extends StatefulWidget {
  const NoteDialog({Key? key}) : super(key: key);

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  String noteText = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Drop a Note"),
      content: TextField(
        autofocus: true,
        maxLines: null,
        onChanged: (value) => noteText = value,
        decoration: const InputDecoration(
          hintText: "Write your note...",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(noteText),
          child: const Text("Drop"),
        ),
      ],
    );
  }
}

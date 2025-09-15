import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String contactAvatarUrl;
  final String contactUsername;

  const ChatPage({
    Key? key,
    required this.contactAvatarUrl,
    required this.contactUsername,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Color pink = const Color(0xFFF43045);
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];

  // OPTIONAL: If you have your current user's avatar URL, set it here.
  final String currentUserAvatarUrl = 'https://randomuser.me/api/portraits/men/35.jpg';

  @override
  void initState() {
    super.initState();
    // Example dummy initial messages
    messages.addAll([
      {
        'fromMe': false,
        'text': "Sounds exactly like I am feeling currently and it is so frustrating I can't even explain.",
        'timestamp': DateTime.now().subtract(const Duration(minutes: 7)),
        'isReply': true,
      },
      {
        'fromMe': true,
        'text': "Fr! How do you deal with this stuff?",
        'timestamp': DateTime.now().subtract(const Duration(minutes: 2)),
      },
    ]);
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add({
          'fromMe': true,
          'text': text,
          'timestamp': DateTime.now(),
        });
        _controller.clear();
      });
    }
  }

  Widget _buildMessage(Map msg) {
    final timeStr = DateFormat('d MMM, yy | h:mm a').format(msg['timestamp']);
    return Row(
      mainAxisAlignment:
          msg['fromMe'] ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!msg['fromMe'])
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 6),
            child: CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(widget.contactAvatarUrl),
              backgroundColor: pink.withOpacity(0.1),
            ),
          ),
        Flexible(
          child: Column(
            crossAxisAlignment:
                msg['fromMe'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (msg['isReply'] ?? false)
                const Text(
                  'Replied to your text',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black45,
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: msg['fromMe'] ? pink : Colors.black12,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  msg['text'],
                  style: TextStyle(
                    color: msg['fromMe'] ? Colors.white : Colors.black87,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                timeStr,
                style: const TextStyle(color: Colors.black45, fontSize: 11),
              ),
            ],
          ),
        ),
        if (msg['fromMe'])
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 6),
            child: CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(currentUserAvatarUrl),
              backgroundColor: pink.withOpacity(0.1),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: pink, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(widget.contactAvatarUrl),
                          backgroundColor: pink.withOpacity(0.11),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.contactUsername,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ListView.separated(
                  reverse: false,
                  itemCount: messages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemBuilder: (context, index) => _buildMessage(messages[index]),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: pink, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                hintText: 'Message...',
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.attach_file, color: pink),
                            onPressed: () {
                              // Add file picker logic here
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.mic, color: pink),
                            onPressed: () {
                              // Add voice recording logic here
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.send, color: pink),
                            onPressed: _sendMessage,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

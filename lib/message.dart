import 'package:flutter/material.dart';
import 'chat.dart'; // Import your ChatPage

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final Color pink = const Color(0xFFF43045);

  final List<Map<String, String>> allChats = [
    {
      'avatar': 'https://randomuser.me/api/portraits/men/12.jpg',
      'username': 'Aman',
      'subtitle': "Fr! How do you deal with this stuff?",
      'time': '2 min ago',
    },
    {
      'avatar': 'https://randomuser.me/api/portraits/women/10.jpg',
      'username': 'Riya',
      'subtitle': "I am passionate about photography and travel.",
      'time': 'Yesterday',
    },
    {
      'avatar': 'https://randomuser.me/api/portraits/women/11.jpg',
      'username': 'Shrishti',
      'subtitle': "I love baking and painting.",
      'time': '1 hour ago',
    },
    {
      'avatar': 'https://randomuser.me/api/portraits/men/43.jpg',
      'username': '@shikhu',
      'subtitle': 'sent you an invite to chat',
      'time': '',
    },
    {
      'avatar': 'https://randomuser.me/api/portraits/women/39.jpg',
      'username': 'Jenny Wilson',
      'subtitle': 'Let\'s meet tomorrow !',
      'time': '2 min ago',
    },
    {
      'avatar': 'https://randomuser.me/api/portraits/men/20.jpg',
      'username': 'Rahul Mehta',
      'subtitle': 'How are you?',
      'time': '1 hour ago',
    },
    {
      'avatar': 'https://randomuser.me/api/portraits/women/5.jpg',
      'username': 'Priya',
      'subtitle': 'Birthday party details...',
      'time': 'Yesterday',
    },
  ];

  String search = '';

  @override
  Widget build(BuildContext context) {
    final chats = allChats.where((chat) {
      final query = search.toLowerCase();
      return chat['username']!.toLowerCase().contains(query) ||
          chat['subtitle']!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 18),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: pink, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Message',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 21,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 35),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: pink,
                borderRadius: BorderRadius.circular(23),
                boxShadow: [
                  BoxShadow(
                      color: pink.withOpacity(0.09),
                      blurRadius: 8,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: TextField(
                style: const TextStyle(fontSize: 16, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search here',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 16.5,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.white, size: 25),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 17),
                ),
                onChanged: (val) => setState(() => search = val),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, i) {
                final chat = chats[i];
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(
                              contactAvatarUrl: chat['avatar']!,
                              contactUsername: chat['username']!,
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(chat['avatar'] ?? ''),
                        radius: 23,
                      ),
                      title: Text(
                        chat['username'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      subtitle: Text(
                        chat['subtitle'] ?? '',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      trailing: (chat['time'] != null && chat['time']!.isNotEmpty)
                          ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
                        decoration: BoxDecoration(
                          color: pink.withOpacity(0.13),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          chat['time']!,
                          style: TextStyle(
                            color: pink,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                          : null,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(height: 1.2),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 62,
        decoration: BoxDecoration(
            color: pink,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(36), topRight: Radius.circular(36))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 26),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/dashboard', (route) => false);
                }),
            IconButton(
                icon: const Icon(Icons.explore, color: Colors.white, size: 26),
                onPressed: () {
                  Navigator.pushNamed(context, '/openstreetmap_search_page');
                }),
            IconButton(
                icon: const Icon(Icons.search, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.pushNamed(context, '/explore');
                }),
            IconButton(
                icon:
                const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 26),
                onPressed: () {
                  Navigator.pushNamed(context, '/message');
                }),
            IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 26),
                onPressed: () {
                  Navigator.pushNamed(context, '/userprofile');
                }),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CafesPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final Color pink = const Color(0xFFF43045);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: pink, size: 26),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      Icon(Icons.add, color: pink),
                      SizedBox(width: 7),
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(
                          "https://randomuser.me/api/portraits/women/44.jpg",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Cafe main card
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: Image.network(
                      imageUrl,
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
                  // "NEW" tag
                  Positioned(
                    left: 15,
                    top: 15,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: pink,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        'NEW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Distance
                  Positioned(
                    right: 15,
                    top: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.87),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(
                        distance,
                        style: TextStyle(
                          color: pink,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ),
                  // Cafe title
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 64,
                    child: Center(
                      child: Text(
                        cafeName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ),
                  // Cafe address
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 41,
                    child: Center(
                      child: Text(
                        address.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.93),
                          fontSize: 13.3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // Social icons row
                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.favorite_border, color: Colors.white, size: 22),
                            const SizedBox(width: 2),
                            Text("318", style: TextStyle(color: Colors.white, fontSize: 14)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.mode_comment_outlined, color: Colors.white, size: 22),
                            const SizedBox(width: 2),
                            Text("321", style: TextStyle(color: Colors.white, fontSize: 14)),
                          ],
                        ),
                        Icon(Icons.event_note, color: Colors.white, size: 21),
                        Icon(Icons.create_outlined, color: Colors.white, size: 21),
                        Icon(Icons.edit_note, color: Colors.white, size: 21),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // What people say
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'What people say about the place',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5,
                  color: Colors.black,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Review card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage:
                    NetworkImage("https://randomuser.me/api/portraits/women/44.jpg"),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$cafeName, ${address.split(',').last}",
                          style: TextStyle(
                            color: pink,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.6,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                          decoration: BoxDecoration(
                            color: pink,
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: Text(
                            reviewText,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.7,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "$reviewDate",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12.2,
                              ),
                            ),
                            const SizedBox(width: 12),
                            TextButton(
                              onPressed: () {},
                              child: Text("Reply",
                                  style: TextStyle(
                                      color: pink,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.3)),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(35, 24),
                              ),
                            ),
                            const SizedBox(width: 7),
                            TextButton(
                              onPressed: () {},
                              child: Text("React",
                                  style: TextStyle(
                                      color: pink,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.3)),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(35, 24),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
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
              icon: const Icon(Icons.home, color: Colors.white, size: 26),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
              },
            ),
            IconButton(
              icon: const Icon(Icons.explore, color: Colors.white, size: 26),
              onPressed: () {
                Navigator.pushNamed(context, '/openstreetmap_search_page');
              },
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pushNamed(context, '/explore');
              },
            ),
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 26),
              onPressed: () {
                Navigator.pushNamed(context, '/message');
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white, size: 26),
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

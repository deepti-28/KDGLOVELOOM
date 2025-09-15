import 'package:flutter/material.dart';
import 'cafes.dart'; // import the cafes.dart file

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final Color pink = const Color(0xFFF43045);
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> places = [
      {
        "image":
        "https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=400&q=80",
        "title": "IQM Cafe",
        "location": "NEW DELHI",
        "distance": "16 km away",
        "address": "123 MG Road, New Delhi",
        "reviewText": "Great atmosphere and coffee!",
        "reviewDate": "Sep 12, 2025",
        "reviewerName": "Eshu",
        "reviewerLocation": "Pune",
      },
      {
        "image":
        "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80",
        "title": "WW Park",
        "location": "NEW DELHI",
        "distance": "4.8 km away",
        "address": "45 Park Street, New Delhi",
        "reviewText": "Perfect spot to relax and unwind.",
        "reviewDate": "Sep 10, 2025",
        "reviewerName": "Amit",
        "reviewerLocation": "Delhi",
      },
      {
        "image":
        "https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80",
        "title": "Social",
        "location": "NEW DELHI",
        "distance": "2.2 km away",
        "address": "88 South Ex, New Delhi",
        "reviewText": "Friendly staff and good vibes.",
        "reviewDate": "Sep 8, 2025",
        "reviewerName": "Priya",
        "reviewerLocation": "Delhi",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            // AppBar Row with Back Arrow
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Back arrow
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: pink, size: 22),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Icon(Icons.place, color: Color(0xFFF43045), size: 18),
                      const SizedBox(width: 5),
                      const Text(
                        "New Delhi",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down,
                          size: 18, color: Colors.black45),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.add, color: pink),
                        onPressed: () {},
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(
                            "https://randomuser.me/api/portraits/women/44.jpg"),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                'Discover',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                  color: Colors.black,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Card scroll - add GestureDetector for navigation
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: places.length,
                padding: const EdgeInsets.only(left: 18, right: 8),
                separatorBuilder: (context, _) => const SizedBox(width: 16),
                itemBuilder: (context, i) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CafesPage(
                          imageUrl: places[i]['image']!,
                          cafeName: places[i]['title']!,
                          address: places[i]['address']!,
                          distance: places[i]['distance']!,
                          reviewText: places[i]['reviewText']!,
                          reviewDate: places[i]['reviewDate']!,
                          reviewerName: places[i]['reviewerName']!,
                          reviewerLocation: places[i]['reviewerLocation']!,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(places[i]['image']!),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 18,
                                offset: Offset(0, 7)),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [
                                Colors.black.withOpacity(0.58),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9),
                                    color: pink,
                                  ),
                                  child: const Text(
                                    'NEW',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  places[i]['distance']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  places[i]['title']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.5,
                                  ),
                                ),
                                Text(
                                  places[i]['location']!,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.93),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // People/Places toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                          color: selectedTab == 0
                              ? pink.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            'Discover people',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: selectedTab == 0 ? pink : Colors.black45,
                              fontSize: 15.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                          color: selectedTab == 1
                              ? pink.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            'Discover places',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: selectedTab == 1 ? pink : Colors.black45,
                              fontSize: 15.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Featured card with post, likes, and profile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=600&q=80',
                      height: 230,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.22),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 22,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.65),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.thumb_up, color: pink, size: 27),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.65),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.message, color: pink, size: 26),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.65),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.more_horiz, color: pink, size: 26),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 23,
                    bottom: 56,
                    child: SizedBox(
                      width: 230,
                      child: Text(
                        "If you could live anywhere in the world, where would you pick?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 17.5,
                          height: 1.29,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 19,
                    bottom: 18,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 17,
                          backgroundImage: NetworkImage(
                              "https://randomuser.me/api/portraits/women/44.jpg"),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "@eshu",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.4,
                              ),
                            ),
                            Text(
                              "PUNE",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 29),
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

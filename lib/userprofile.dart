import 'package:flutter/material.dart';
import 'editprofile.dart';

class UserProfilePage extends StatelessWidget {
  final String avatarUrl;
  final String username;
  final String name;
  final String location;
  final int age;
  final String aboutMe;
  final List<String> galleryImages;

  const UserProfilePage({
    Key? key,
    required this.avatarUrl,
    required this.username,
    required this.name,
    required this.location,
    required this.age,
    required this.aboutMe,
    required this.galleryImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pink = const Color(0xFFF43045);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 14),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: pink, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Profile',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfilePage(
                          name: name,
                          dob: '', // Pass actual DOB if available
                          initialImage: avatarUrl,
                          initialLocation: location,
                          initialGalleryImages: galleryImages,
                          initialNotes: const [], // Pass notes if needed
                          initialDob: '', // Pass actual DOB if available
                          initialName: name,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 18),
                    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Center(
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: pink, width: 4),
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 52,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                username,
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
            ),
            Center(
              child: Text(
                '$location, $age',
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 21),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About me',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5),
                  ),
                  SizedBox(height: 6),
                  Text(
                    aboutMe.length > 120
                        ? aboutMe.substring(0, 120) + '... '
                        : aboutMe,
                    style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.36),
                  ),
                  InkWell(
                    onTap: () {}, // Open full bio
                    child: Text(
                      'read more..',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: pink,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  Text(
                    'Gallery',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Add Image',
                      style: TextStyle(color: pink, fontWeight: FontWeight.bold, fontSize: 13.5),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 9),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: galleryImages.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(galleryImages[i], fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 62,
        decoration: BoxDecoration(
          color: pink,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.home, color: Colors.white, size: 26),
            Icon(Icons.explore, color: Colors.white, size: 26),
            Icon(Icons.search, color: Colors.white, size: 27),
            Icon(Icons.chat_bubble_outline, color: Colors.white, size: 26),
            Icon(Icons.person, color: Colors.white, size: 26),
          ],
        ),
      ),
    );
  }
}

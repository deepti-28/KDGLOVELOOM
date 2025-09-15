import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'userdata.dart'; // Assumed to define your `users` list and User model
import 'chat.dart'; // The chat page you'll navigate to

class OpenStreetMapSearchPage extends StatefulWidget {
  @override
  _OpenStreetMapSearchPageState createState() => _OpenStreetMapSearchPageState();
}

class _OpenStreetMapSearchPageState extends State<OpenStreetMapSearchPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  LatLng _mapCenter = LatLng(28.6139, 77.2090); // Default to Delhi
  double _zoom = 12;
  Marker? _searchedMarker;

  Future<void> _searchLocation(String location) async {
    if (location.trim().isEmpty) return;
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        if (!mounted) return;
        setState(() {
          _mapCenter = LatLng(loc.latitude, loc.longitude);
          _zoom = 13.0;
          _searchedMarker = Marker(
            width: 40,
            height: 40,
            point: _mapCenter,
            builder: (ctx) => Icon(Icons.location_on, size: 38, color: Colors.red),
          );
        });
        _mapController.move(_mapCenter, _zoom);
      } else {
        if (!mounted) return;
        _showError('Location not found');
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Error searching location');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _openChat(user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          contactUsername: user.name,
          contactAvatarUrl: user.profileImageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for a location',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => _searchLocation(_searchController.text),
            ),
            border: InputBorder.none,
          ),
          onSubmitted: _searchLocation,
          textInputAction: TextInputAction.search,
        ),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _mapCenter,
          zoom: _zoom,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              if (_searchedMarker != null) _searchedMarker!,
              ...users.map((user) => Marker(
                width: 70,
                height: 70,
                point: user.location,
                builder: (_) => GestureDetector(
                  onTap: () => _openChat(user),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.amber,
                        width: 5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user.profileImageUrl),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}

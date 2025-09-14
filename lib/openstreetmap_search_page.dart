import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

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
          MarkerLayer(markers: _searchedMarker != null ? [_searchedMarker!] : []),
        ],
      ),
    );
  }
}

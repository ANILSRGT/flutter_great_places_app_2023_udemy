import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place_location.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;
  const MapScreen({
    super.key,
    this.initialLocation = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
      address: null,
    ),
    this.isSelecting = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _selectedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_selectedLocation);
                    },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.initialLocation.latitude, widget.initialLocation.longitude),
          zoom: 16,
        ),
        markers: {
          if (_selectedLocation != null)
            Marker(
              markerId: const MarkerId('A'),
              position: _selectedLocation!,
            ),
          if (!widget.isSelecting)
            Marker(
              markerId: const MarkerId('A'),
              position: LatLng(widget.initialLocation.latitude, widget.initialLocation.longitude),
            ),
        },
        onTap: widget.isSelecting ? _selectLocation : null,
      ),
    );
  }
}

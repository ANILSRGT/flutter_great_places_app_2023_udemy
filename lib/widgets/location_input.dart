import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../core/helper/location/location_helper.dart';
import '../core/init/navigation/core_router.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final void Function(double lat, double lng) onSelectPlace;
  const LocationInput(this.onSelectPlace, {super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    if (locData.latitude == null || locData.longitude == null) {
      return await Future.delayed(Duration.zero).then((value) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Could not get your location.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      });
    }
    _showPreview(locData.latitude!, locData.longitude!);
    widget.onSelectPlace(locData.latitude!, locData.longitude!);
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await CoreRouter.navigatorKey.currentState?.push(
      CoreRouter.materialPageRoute(
        const MapScreen(isSelecting: true),
        fullScreenDialog: true,
      ),
    ) as LatLng?;
    if (selectedLocation == null) return;
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? const Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

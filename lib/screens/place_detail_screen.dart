import 'package:flutter/material.dart';
import '../core/init/navigation/core_router.dart';
import '../providers/great_places_notifier.dart';
import 'map_screen.dart';
import 'package:provider/provider.dart';

import '../models/place_location.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key});

  void _viewOnMap(PlaceLocation location) {
    CoreRouter.navigatorKey.currentState?.push(
      CoreRouter.materialPageRoute(
        MapScreen(
          initialLocation: location,
          isSelecting: false,
        ),
        fullScreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final placeId = ModalRoute.of(context)?.settings.arguments as String;
    final selectedPlace = context.read<GreatPlacesNotifier>().findById(placeId);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            selectedPlace.location == null
                ? 'No Location Chosen!'
                : (selectedPlace.location!.address ?? 'No Address Found!'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed:
                selectedPlace.location == null ? null : () => _viewOnMap(selectedPlace.location!),
            icon: const Icon(Icons.map),
            label: const Text('View on Map'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

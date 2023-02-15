import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/navigation/route_constants.dart';
import '../core/init/navigation/core_router.dart';
import '../providers/great_places_notifier.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              CoreRouter.navigatorKey.currentState?.pushNamed(RouteConstants.addPlaceScreen);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: context.read<GreatPlacesNotifier>().fetchAndSetPlaces(),
        builder: (ctx, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<GreatPlacesNotifier>(
                  builder: (ctx, greatPlacesData, child) {
                    return greatPlacesData.items.isEmpty
                        ? child!
                        : ListView.builder(
                            itemCount: greatPlacesData.items.length,
                            itemBuilder: (ctx, i) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: FileImage(
                                  greatPlacesData.items[i].image,
                                ),
                              ),
                              title: Text(greatPlacesData.items[i].title),
                              subtitle:
                                  Text(greatPlacesData.items[i].location?.address ?? 'No address!'),
                              onTap: () {
                                CoreRouter.navigatorKey.currentState?.pushNamed(
                                  RouteConstants.placeDetailScreen,
                                  arguments: greatPlacesData.items[i].id,
                                );
                              },
                            ),
                          );
                  },
                  child: const Center(
                    child: Text('Got no places yet, start adding some!'),
                  ),
                );
        },
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/cache/db_tables_enum.dart';
import '../core/helper/location/location_helper.dart';
import '../core/init/cache/database_manager.dart';
import '../models/place.dart';
import '../models/place_location.dart';

class GreatPlacesNotifier with ChangeNotifier {
  final List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(String pickedTitle, File pickedImage, PlaceLocation location) async {
    final address = await LocationHelper.getPlaceAddress(location.latitude, location.longitude);
    final updatedLocation = location.copyWith(address: address);
    final newPlace = Place(
      id: const Uuid().v4(),
      title: pickedTitle,
      image: pickedImage,
      location: updatedLocation,
    );
    await DatabaseManager.instance.insert(DBTablesEnum.places, {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location!.latitude,
      'loc_lng': newPlace.location!.longitude,
      'address': newPlace.location!.address,
    });
    _items.add(newPlace);
    notifyListeners();
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DatabaseManager.instance.getData(DBTablesEnum.places);
    _items.clear();
    dataList.map((item) {
      final location = PlaceLocation(
        latitude: item['loc_lat'],
        longitude: item['loc_lng'],
        address: item['address'],
      );
      return _items.add(Place(
        id: item['id'],
        title: item['title'],
        image: File(item['image']),
        location: location,
      ));
    }).toList();
    notifyListeners();
  }
}

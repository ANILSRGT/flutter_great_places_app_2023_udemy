import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/place_location.dart';
import '../providers/great_places_notifier.dart';
import '../widgets/image_input.dart';
import '../widgets/location_input.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _pickedImage;
  PlaceLocation? _pickedLocation;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  void _savePlace() {
    if (_titleController.text.isEmpty || _pickedImage == null || _pickedLocation == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Please provide the required fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
      return;
    }
    context.read<GreatPlacesNotifier>().addPlace(
          _titleController.text,
          _pickedImage!,
          _pickedLocation!,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 10),
                    ImageInput(_selectImage),
                    const SizedBox(height: 10),
                    LocationInput(_selectPlace),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _savePlace,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Place'),
          ),
        ],
      ),
    );
  }
}

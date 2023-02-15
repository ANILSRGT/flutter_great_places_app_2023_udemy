import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'great_places_notifier.dart';

class ProviderList {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider.value(value: GreatPlacesNotifier()),
  ];
}

import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotEnvManager {
  static final DotEnvManager _instance = DotEnvManager._init();
  static DotEnvManager get instance => _instance;

  DotEnvManager._init();

  static Future<void> initEnv() async {
    await dotenv.load(fileName: '.env');
  }

  String get googleApiKey => dotenv.get('GOOGLE_API_KEY', fallback: '');
}

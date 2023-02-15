import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/init/cache/database_manager.dart';
import 'core/init/dotenv/dotenv_manager.dart';
import 'core/init/navigation/core_router.dart';
import 'providers/provider_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnvManager.initEnv();
  await DatabaseManager.databaseInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProviderList.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Great Places',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          colorScheme: const ColorScheme.light(
            secondary: Colors.amber,
            onSecondary: Colors.black,
          ),
        ),
        initialRoute: CoreRouter.initialRoute,
        onGenerateRoute: CoreRouter.generateRoute,
        navigatorKey: CoreRouter.navigatorKey,
      ),
    );
  }
}

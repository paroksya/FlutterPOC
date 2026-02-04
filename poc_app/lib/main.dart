import 'package:flutter/material.dart';

import 'providers/multi_provider/app_provider.dart';
import 'screens/home_screen.dart';
import 'services/shared_preferences_servces.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppMultiProvider(
      child: MaterialApp(
        title: 'POC App',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

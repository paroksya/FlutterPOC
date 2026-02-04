import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_screen_provider.dart';

class AppMultiProvider extends StatelessWidget {
  final Widget child;
  const AppMultiProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeScreenProvider>(
          create: (context) => HomeScreenProvider(),
        ),
      ],
      child: child,
    );
  }
}

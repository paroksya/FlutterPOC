import 'package:flutter/material.dart';

class AppUrls {
  static GlobalKey<NavigatorState> materialKey = GlobalKey<NavigatorState>();
  // Full API URL
  static String get apiUrl => 'https://jsonplaceholder.typicode.com/';
}

BuildContext? get globalBuildContext =>
    AppUrls.materialKey.currentState?.context;

bool get globalBuildContextExits => AppUrls.materialKey.currentContext != null;

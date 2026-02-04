import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _prefs;
  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Get SharedPreferences instance
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception(
        'SharedPreferences not initialized. Call SharedPreferencesService.init() first.',
      );
    }
    return _prefs!;
  }

  // STRING OPERATIONS
  static Future<bool> setString(String key, String value) async {
    try {
      return await prefs.setString(key, value);
    } catch (e) {
      log('Error saving string: $e');
      return false;
    }
  }

  static String getString(String key, {String defaultValue = ''}) {
    try {
      return prefs.getString(key) ?? defaultValue;
    } catch (e) {
      log('Error getting string: $e');
      return defaultValue;
    }
  }

  // LIST OF STRING OPERATIONS
  static Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await prefs.setStringList(key, value);
    } catch (e) {
      log('Error saving string: $e');
      return false;
    }
  }

  static List<String> getStringList(String key) {
    try {
      return prefs.getStringList(key) ?? [];
    } catch (e) {
      log('Error getting string: $e');
      return [];
    }
  }

  // INTEGER OPERATIONS
  static Future<bool> setInt(String key, int value) async {
    try {
      return await prefs.setInt(key, value);
    } catch (e) {
      log('Error saving int: $e');
      return false;
    }
  }

  static int getInt(String key, {int defaultValue = 0}) {
    try {
      return prefs.getInt(key) ?? defaultValue;
    } catch (e) {
      log('Error getting int: $e');
      return defaultValue;
    }
  }

  // DOUBLE OPERATIONS
  static Future<bool> setDouble(String key, double value) async {
    try {
      return await prefs.setDouble(key, value);
    } catch (e) {
      log('Error saving double: $e');
      return false;
    }
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    try {
      return prefs.getDouble(key) ?? defaultValue;
    } catch (e) {
      log('Error getting double: $e');
      return defaultValue;
    }
  }

  // BOOLEAN OPERATIONS
  static Future<bool> setBool(String key, bool value) async {
    try {
      return await prefs.setBool(key, value);
    } catch (e) {
      log('Error saving bool: $e');
      return false;
    }
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    try {
      return prefs.getBool(key) ?? defaultValue;
    } catch (e) {
      log('Error getting bool: $e');
      return defaultValue;
    }
  }

  static Future<bool> remove(String key) async {
    try {
      return await prefs.remove(key);
    } catch (e) {
      log('Error removing key: $e');
      return false;
    }
  }

  static Future<bool> clear() async {
    try {
      return await prefs.clear();
    } catch (e) {
      log('Error clearing preferences: $e');
      return false;
    }
  }

  static Set<String> getKeys() {
    try {
      return prefs.getKeys();
    } catch (e) {
      log('Error getting keys: $e');
      return <String>{};
    }
  }

  // RELOAD (useful for testing)
  static Future<void> reload() async {
    try {
      await prefs.reload();
    } catch (e) {
      log('Error reloading preferences: $e');
    }
  }
}

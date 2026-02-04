import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../models/user_model.dart';
import '../services/dio_services.dart';
import '../services/shared_preferences_servces.dart';

class HomeScreenProvider extends ChangeNotifier {
  final HttpService _httpService = HttpService();

  // User data
  bool isUserDataLoading = false;
  List<UserModel> users = [];

  // Post data
  bool isPostDataLoading = false;
  List<PostModel> posts = [];

  // Bookmark data
  static const String _bookmarkKey = 'bookmarked_post_ids';
  Set<int> bookmarkedPostIds = {};

  Future<void> getUsers() async {
    isUserDataLoading = true;
    notifyListeners();

    try {
      Response response = await _httpService.get(endPoint: '/users');

      if (response.statusCode == 200 && response.data is List) {
        users = (response.data as List)
            .map((e) => UserModel.fromJson(e))
            .toList();

        log('Users fetched: ${users.length}');
      } else {
        users = [];
      }
    } catch (e) {
      users = [];
      debugPrint('Fetch users error: $e');
    } finally {
      isUserDataLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPosts() async {
    isPostDataLoading = true;
    notifyListeners();

    try {
      Response response = await _httpService.get(endPoint: '/posts');

      if (response.statusCode == 200 && response.data is List) {
        posts = (response.data as List)
            .map((e) => PostModel.fromJson(e))
            .toList();

        log('Posts fetched: ${posts.length}');
      } else {
        posts = [];
      }
    } catch (e) {
      posts = [];
      debugPrint('Fetch posts error: $e');
    } finally {
      isPostDataLoading = false;
      notifyListeners();
    }
  }

  void loadBookmarks() {
    final list = SharedPreferencesService.getStringList(_bookmarkKey);
    bookmarkedPostIds = list.map(int.parse).toSet();
    notifyListeners();
  }

  bool isBookmarked(int postId) {
    return bookmarkedPostIds.contains(postId);
  }

  Future<void> toggleBookmark(int postId) async {
    if (bookmarkedPostIds.contains(postId)) {
      bookmarkedPostIds.remove(postId);
    } else {
      bookmarkedPostIds.add(postId);
    }

    await SharedPreferencesService.setStringList(
      _bookmarkKey,
      bookmarkedPostIds.map((e) => e.toString()).toList(),
    );

    notifyListeners();
  }

  // Get bookmarked posts
  List<PostModel> get bookmarkedPosts {
    return posts.where((post) => bookmarkedPostIds.contains(post.id)).toList();
  }
}

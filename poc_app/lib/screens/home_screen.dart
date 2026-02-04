import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/common_header.dart';
import '../components/post_card_widget.dart';
import '../models/post_model.dart';
import '../providers/home_screen_provider.dart';
import '../utils/app_colors.dart';
import 'bookmark_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  String _searchQuery = '';

  final TextEditingController searchFeedController = TextEditingController();

  List<PostModel> get filteredPosts {
    final provider = Provider.of<HomeScreenProvider>(context, listen: false);

    return provider.posts.where((post) {
      final search = _searchQuery.toLowerCase();

      final matchesSearch = post.title.toLowerCase().contains(search);

      return matchesSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        HomeScreenProvider homeScreenProvider = Provider.of<HomeScreenProvider>(
          context,
          listen: false,
        );

        // Load bookmarks from SharedPreferences
        homeScreenProvider.loadBookmarks();

        await Future.wait([
          homeScreenProvider.getUsers(),
          homeScreenProvider.getPosts(),
        ]);

        log("Data fetched successfully");
      } catch (e) {
        log("Error fetching data");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<HomeScreenProvider>(
          builder: (context, homeScreenProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // headerWidget(),
                CommonHeader(
                  title: 'POC Demo',
                  showAction: true,
                  onActionTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BookmarkScreen()),
                    );
                  },
                ),
                const SizedBox(height: 8),
                searchBarWidget(
                  controller: searchFeedController,
                  onChanged: (String value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  suffixIcon: searchFeedController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchFeedController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          icon: Icon(Icons.clear, size: 16),
                          color: AppColors.grey,
                        )
                      : null,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: isLoading || homeScreenProvider.isPostDataLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : filteredPosts.isEmpty
                      ? emptyDataWidget()
                      : ListView.builder(
                          itemCount: filteredPosts.length,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemBuilder: (context, index) {
                            final post = filteredPosts[index];
                            final user = homeScreenProvider.users.firstWhere(
                              (u) => u.id == post.userId,
                            );

                            return PostCardWidget(
                              postdata: post,
                              userData: user,
                              homeScreenProvider: homeScreenProvider,
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget searchBarWidget({
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.searchContainerBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Filter posts by title…',
            hintStyle: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget emptyDataWidget() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 100),
          Icon(Icons.search_off_rounded, size: 48, color: AppColors.black38),
          SizedBox(height: 12),
          Text(
            'No posts found',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/common_header.dart';
import '../components/post_card_widget.dart';
import '../providers/home_screen_provider.dart';
import '../utils/app_colors.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<HomeScreenProvider>(
          builder: (context, homeScreenProvider, child) {
            final bookmarkedPosts = homeScreenProvider.bookmarkedPosts;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonHeader(title: 'Bookmarks', showBack: true),
                const SizedBox(height: 8),
                Expanded(
                  child: bookmarkedPosts.isEmpty
                      ? const Center(
                          child: Text(
                            'No bookmarked posts',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: bookmarkedPosts.length,
                          itemBuilder: (context, index) {
                            final post = bookmarkedPosts[index];

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
}

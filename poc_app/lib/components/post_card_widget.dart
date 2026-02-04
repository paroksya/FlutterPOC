import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../models/user_model.dart';
import '../providers/home_screen_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_style.dart';

class PostCardWidget extends StatefulWidget {
  final PostModel postdata;
  final UserModel userData;
  final HomeScreenProvider homeScreenProvider;

  const PostCardWidget({
    super.key,
    required this.postdata,
    required this.userData,
    required this.homeScreenProvider,
  });

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        color: AppColors.cardBg,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userInfoWidget(
              postdata: widget.postdata,
              userData: widget.userData,
              homeScreenProvider: widget.homeScreenProvider,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Text(widget.postdata.title, style: AppTextStyle.postTitle),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.postdata.body,
                style: AppTextStyle.postBody,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userInfoWidget({
    required PostModel postdata,
    required UserModel userData,
    required HomeScreenProvider homeScreenProvider,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          avatarWidget(firstLetter: userData.name[0]),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userData.name, style: AppTextStyle.userName),
                Text(userData.email, style: AppTextStyle.userEmail),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              homeScreenProvider.isBookmarked(postdata.id)
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_add_rounded,
              color: homeScreenProvider.isBookmarked(postdata.id)
                  ? AppColors.primary
                  : AppColors.grey,
            ),
            onPressed: () {
              homeScreenProvider.toggleBookmark(postdata.id);
            },
          ),
        ],
      ),
    );
  }

  Widget avatarWidget({required String firstLetter}) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          firstLetter,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

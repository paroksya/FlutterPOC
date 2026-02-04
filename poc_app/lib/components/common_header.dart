import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_style.dart';

class CommonHeader extends StatelessWidget {
  final String title;

  // Back button
  final bool showBack;
  final VoidCallback? onBackTap;

  // Action button (bookmark)
  final bool showAction;
  final IconData actionIcon;
  final VoidCallback? onActionTap;

  const CommonHeader({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBackTap,
    this.showAction = false,
    this.actionIcon = Icons.bookmark_rounded,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(showBack ? 10 : 20, 12, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (showBack)
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: onBackTap ?? () => Navigator.pop(context),
                )
              else
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.article_rounded, color: Colors.white),
                ),

              const SizedBox(width: 12),
              Text(title, style: AppTextStyle.title),
            ],
          ),

          // Action button
          if (showAction)
            IconButton(icon: Icon(actionIcon), onPressed: onActionTap),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyle {
  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle postTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 0,
  );

  static const TextStyle postBody = TextStyle(
    fontSize: 14,
    height: 1.3,
    color: AppColors.textSecondary,
  );

  static const TextStyle userName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle userEmail = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}

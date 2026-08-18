import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PaginationFooter extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int startItem;
  final int endItem;
  final int totalItems;

  const PaginationFooter({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.startItem,
    required this.endItem,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(color: AppColors.outline),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $startItem-$endItem of $totalItems codes',
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              _buildNavButton(
                icon: Icons.chevron_left,
                onPressed: currentPage > 1 ? () {} : null,
              ),
              const SizedBox(width: 4),
              _buildPageButton(1, isActive: currentPage == 1),
              const SizedBox(width: 4),
              _buildPageButton(2, isActive: currentPage == 2),
              const SizedBox(width: 4),
              _buildPageButton(3, isActive: currentPage == 3),
              const SizedBox(width: 4),
              const SizedBox(
                width: 32,
                height: 32,
                child: Center(
                  child: Text(
                    '...',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              _buildNavButton(
                icon: Icons.chevron_right,
                onPressed: currentPage < totalPages ? () {} : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({required IconData icon, VoidCallback? onPressed}) {
    return SizedBox(
      width: 32,
      height: 32,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: AppColors.onSurface,
          disabledForegroundColor: AppColors.onSurfaceVariant.withOpacity(0.5),
          side: BorderSide(
            color: onPressed != null ? AppColors.outline : AppColors.outline.withOpacity(0.5),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _buildPageButton(int page, {required bool isActive}) {
    return SizedBox(
      width: 32,
      height: 32,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: isActive ? AppColors.surfaceContainerHigh : Colors.transparent,
          foregroundColor: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(
              color: isActive ? AppColors.primary : AppColors.outline,
            ),
          ),
        ),
        child: Text(
          page.toString(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

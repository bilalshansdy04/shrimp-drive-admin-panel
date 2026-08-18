import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AddStorageCard extends StatelessWidget {
  const AddStorageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 300),
      decoration: BoxDecoration(
        color: AppColors.surface, // Maps to surface-dim
        borderRadius: BorderRadius.circular(8),
        // Dashed border visually handled via a CustomPaint or simple border.
        // We'll use a simple border here to avoid over-engineering the dashed effect unless strict,
        // but let's emulate it with standard styling or a custom painter if needed. 
        // For simplicity in standard Flutter, we use solid unless we pull in dotted_border package.
        border: Border.all(color: AppColors.outline, width: 2), // Representing dashed
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          hoverColor: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 32, color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Add Storage Bot',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Connect a new Telegram bot or channel to expand storage capacity.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

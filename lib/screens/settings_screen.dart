import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column (Navigation)
            const Expanded(
              flex: 3,
              child: _SettingsNavigation(),
            ),
            const SizedBox(width: 32),
            // Right Column (Content Forms)
            Expanded(
              flex: 9,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _SettingsHeader(),
                    SizedBox(height: 32),
                    _DatabaseConfigSection(),
                    SizedBox(height: 32),
                    _SecuritySection(),
                    SizedBox(height: 32),
                    _PreferencesSection(),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 32,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Manage your admin panel preferences and connections.',
          style: TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _SettingsNavigation extends StatelessWidget {
  const _SettingsNavigation();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNavItem(
          icon: Icons.storage,
          label: 'Database Configuration',
          isActive: true,
        ),
        const SizedBox(height: 4),
        _buildNavItem(
          icon: Icons.security,
          label: 'Security & Authentication',
          isActive: false,
        ),
        const SizedBox(height: 4),
        _buildNavItem(
          icon: Icons.tune,
          label: 'System Preferences',
          isActive: false,
        ),
      ],
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required bool isActive}) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? AppColors.surfaceContainerHigh : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border(
          left: BorderSide(
            color: isActive ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          hoverColor: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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

// Reusable Section Container
class _SectionContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget content;
  final Widget action;

  const _SectionContainer({
    required this.title,
    required this.subtitle,
    required this.content,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
              border: const Border(bottom: BorderSide(color: AppColors.outline)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Section Body
          Padding(
            padding: const EdgeInsets.all(24),
            child: content,
          ),
          // Section Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.outline)),
            ),
            alignment: Alignment.centerRight,
            child: action,
          ),
        ],
      ),
    );
  }
}

// Reusable TextField
Widget _buildTextField({
  required String label,
  required String hint,
  IconData? prefixIcon,
  Widget? suffixIcon,
  bool isPassword = false,
  bool isMonospace = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: AppColors.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        obscureText: isPassword,
        style: TextStyle(
          color: AppColors.onSurface,
          fontSize: 14,
          fontFamily: isMonospace ? 'monospace' : null,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
            fontSize: 14,
          ),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.onSurfaceVariant, size: 18) : null,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: AppColors.surface, // surface-dim
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.primaryContainer), // Glow color in HTML
          ),
        ),
      ),
    ],
  );
}

class _DatabaseConfigSection extends StatelessWidget {
  const _DatabaseConfigSection();

  @override
  Widget build(BuildContext context) {
    return _SectionContainer(
      title: 'Database Configuration',
      subtitle: 'Manage your central Turso database connection.',
      content: Column(
        children: [
          _buildTextField(
            label: 'DATABASE URL',
            hint: 'libsql://...',
            prefixIcon: Icons.link,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'AUTHENTICATION TOKEN',
            hint: '••••••••',
            prefixIcon: Icons.key,
            isPassword: true,
            isMonospace: true,
            suffixIcon: IconButton(
              icon: const Icon(Icons.visibility, size: 18, color: AppColors.onSurfaceVariant),
              onPressed: () {},
            ),
          ),
        ],
      ),
      action: FilledButton(
        onPressed: () {},
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: const Text('Save Configuration', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _SecuritySection extends StatelessWidget {
  const _SecuritySection();

  @override
  Widget build(BuildContext context) {
    return _SectionContainer(
      title: 'Security & Authentication',
      subtitle: 'Update your admin credentials.',
      content: Column(
        children: [
          _buildTextField(
            label: 'CURRENT PASSWORD',
            hint: '••••••••',
            isPassword: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'NEW PASSWORD',
                  hint: '••••••••',
                  isPassword: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label: 'CONFIRM NEW PASSWORD',
                  hint: '••••••••',
                  isPassword: true,
                ),
              ),
            ],
          ),
        ],
      ),
      action: FilledButton(
        onPressed: () {},
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: const Text('Update Security', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _PreferencesSection extends StatelessWidget {
  const _PreferencesSection();

  @override
  Widget build(BuildContext context) {
    return _SectionContainer(
      title: 'System Preferences',
      subtitle: 'Customize the admin console experience.',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'INTERFACE THEME',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildThemeCard(title: 'Dark Mode', icon: Icons.dark_mode, isSelected: true)),
              const SizedBox(width: 16),
              Expanded(child: _buildThemeCard(title: 'Light Mode', icon: Icons.light_mode, isSelected: false)),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.outline),
          const SizedBox(height: 24),
          const Text(
            'DISPLAY LANGUAGE',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          // We can use DropdownButtonFormField or just a stylized container to mock it up
          SizedBox(
            width: 300,
            child: DropdownButtonFormField<String>(
              value: 'en',
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.onSurfaceVariant),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.language, color: AppColors.onSurfaceVariant, size: 18),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppColors.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppColors.primaryContainer),
                ),
              ),
              dropdownColor: AppColors.surfaceContainerHigh,
              style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'id', child: Text('Indonesia')),
              ],
              onChanged: (val) {},
            ),
          ),
        ],
      ),
      action: const SizedBox(), // No action button required for preferences in design
    );
  }

  Widget _buildThemeCard({required String title, required IconData icon, required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.surfaceContainer : AppColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.outline),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

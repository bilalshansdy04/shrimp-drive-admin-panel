import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/api_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isLoading = true;
  String? _errorMsg;

  // General Settings State
  final _baseStorageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      final api = ref.read(apiServiceProvider);
      final settings = await api.getSettings();

      if (settings.containsKey('default_base_storage')) {
        // convert bytes to GB for display
        final bytes = int.tryParse(settings['default_base_storage']!) ?? 8589934592;
        final gb = bytes ~/ (1024 * 1024 * 1024);
        _baseStorageController.text = gb.toString();
      } else {
        _baseStorageController.text = '8';
      }
    } catch (e) {
      setState(() => _errorMsg = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveGeneralSettings() async {
    final api = ref.read(apiServiceProvider);
    try {
      final gb = int.tryParse(_baseStorageController.text) ?? 8;
      final bytes = gb * 1024 * 1024 * 1024;
      
      await api.updateSettings({
        'default_base_storage': bytes.toString(),
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save settings: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
                  children: [
                    const _SettingsHeader(),
                    const SizedBox(height: 32),
                    if (_errorMsg != null)
                      Text('Error loading settings: $_errorMsg', style: const TextStyle(color: AppColors.error)),
                    _GeneralSettingsSection(
                      baseStorageController: _baseStorageController,
                      onSave: _saveGeneralSettings,
                    ),
                    const SizedBox(height: 32),
                    const _PreferencesSection(),
                    const SizedBox(height: 32),
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
          'Manage global application settings and admin panel preferences.',
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
          icon: Icons.settings,
          label: 'General Settings',
          isActive: true,
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

class _GeneralSettingsSection extends StatelessWidget {
  final TextEditingController baseStorageController;
  final VoidCallback onSave;

  const _GeneralSettingsSection({
    required this.baseStorageController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionContainer(
      title: 'General Settings',
      subtitle: 'Manage global configurations for Shrimp Drive users.',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DEFAULT BASE STORAGE (GB)',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: baseStorageController,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 14,
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'e.g. 8',
              hintStyle: TextStyle(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                fontSize: 14,
              ),
              prefixIcon: const Icon(Icons.storage, color: AppColors.onSurfaceVariant, size: 18),
              suffixText: 'GB',
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
          const SizedBox(height: 8),
          const Text(
            'This applies to all new users when they register.',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
          ),
        ],
      ),
      action: FilledButton(
        onPressed: onSave,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: const Text('Save Settings', style: TextStyle(fontWeight: FontWeight.bold)),
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
      subtitle: 'Customize the admin console experience (Local to this device).',
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
          SizedBox(
            width: 300,
            child: DropdownButtonFormField<String>(
              initialValue: 'en',
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
      action: const SizedBox(), 
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
            style: const TextStyle(
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

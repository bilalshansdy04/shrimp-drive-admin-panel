import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/invitation_code.dart';
import '../providers/invitation_codes_provider.dart';
import '../providers/telegram_nodes_provider.dart';
import '../theme/app_theme.dart';

class InvitationCodeFormDialog extends ConsumerStatefulWidget {
  final InvitationCode? existingCode;

  const InvitationCodeFormDialog({super.key, this.existingCode});

  @override
  ConsumerState<InvitationCodeFormDialog> createState() => _InvitationCodeFormDialogState();
}

class _InvitationCodeFormDialogState extends ConsumerState<InvitationCodeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  
  late String _code;
  late String _type;
  late String _encryptionMode;
  late String _maxUses;
  late String _bonusAmountGB;
  
  String? _selectedNodeId;
  
  bool _isLimitless = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(telegramNodesProvider.notifier).build());

    _code = widget.existingCode?.code ?? '';
    _type = widget.existingCode?.type ?? 'friend_zero_setup';
    _encryptionMode = widget.existingCode?.encryptionMode ?? 'locked_on';
    _maxUses = widget.existingCode?.maxUses.toString() ?? '1';
    
    if (widget.existingCode != null) {
      _selectedNodeId = widget.existingCode!.assignedNodeId;
      _isLimitless = widget.existingCode!.bonusAmount == null || widget.existingCode!.bonusAmount == 0;
      if (!_isLimitless) {
        _bonusAmountGB = (widget.existingCode!.bonusAmount! / (1024 * 1024 * 1024)).toStringAsFixed(0);
      } else {
        _bonusAmountGB = '50';
      }
    } else {
      _bonusAmountGB = '50';
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      
      final data = <String, dynamic>{
        'type': _type,
        'encryptionMode': _encryptionMode,
        'maxUses': int.tryParse(_maxUses) ?? 1,
      };

      if (_type == 'friend_zero_setup') {
        if (_selectedNodeId != null) {
          data['assignedNodeId'] = _selectedNodeId;
        }
      }

      if (!_isLimitless) {
        final gb = double.tryParse(_bonusAmountGB) ?? 0;
        data['bonusAmount'] = (gb * 1024 * 1024 * 1024).toInt(); // Convert GB to Bytes
      } else {
        data['bonusAmount'] = 0; // Limitless
      }

      if (widget.existingCode == null) {
        // Create
        if (_code.trim().isNotEmpty) {
          data['code'] = _code.trim();
        }
        ref.read(invitationCodesProvider.notifier).createCode(data);
      } else {
        // Update
        ref.read(invitationCodesProvider.notifier).updateCode(widget.existingCode!.code, data);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingCode != null;
    final nodesAsync = ref.watch(telegramNodesProvider);

    return AlertDialog(
      backgroundColor: AppColors.surfaceContainer,
      title: Text(isEdit ? 'Edit Invitation Code' : 'Create Invitation Code', style: const TextStyle(color: AppColors.onSurface)),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _code,
                  enabled: !isEdit,
                  decoration: const InputDecoration(
                    labelText: 'Code Name (Optional)',
                    hintText: 'Leave empty to auto-generate',
                  ),
                  maxLength: 6,
                  style: const TextStyle(color: AppColors.onSurface),
                  onSaved: (val) => _code = val ?? '',
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _type,
                  decoration: const InputDecoration(labelText: 'Setup Type'),
                  items: const [
                    DropdownMenuItem(value: 'friend_zero_setup', child: Text('Pakai Storage Ku (Zero Setup)')),
                    DropdownMenuItem(value: 'regular_self_setup', child: Text('Pakai Storage Sendiri (Self Setup)')),
                  ],
                  dropdownColor: AppColors.surfaceContainerHigh,
                  style: const TextStyle(color: AppColors.onSurface),
                  onChanged: (val) {
                    if (val != null) setState(() => _type = val);
                  },
                  onSaved: (val) {
                    if (val != null) _type = val;
                  },
                ),
                if (_type == 'friend_zero_setup') ...[
                  const SizedBox(height: 16),
                  nodesAsync.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (err, stack) => Text('Error loading nodes: $err', style: const TextStyle(color: AppColors.error)),
                    data: (nodes) {
                      if (_selectedNodeId == null && nodes.isNotEmpty && !isEdit) {
                         // Default to first node if available
                        _selectedNodeId = nodes.first.id;
                      }

                      final items = nodes.map((node) => DropdownMenuItem(
                        value: node.id,
                        child: Text(node.name),
                      )).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            initialValue: _selectedNodeId,
                            decoration: const InputDecoration(labelText: 'Select Storage Node'),
                            items: items,
                            dropdownColor: AppColors.surfaceContainerHigh,
                            style: const TextStyle(color: AppColors.onSurface),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedNodeId = val);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
                const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _encryptionMode,
                    decoration: const InputDecoration(labelText: 'Encryption Mode'),
                  items: const [
                    DropdownMenuItem(value: 'locked_on', child: Text('Locked On (Encrypted)')),
                    DropdownMenuItem(value: 'locked_off', child: Text('Locked Off (Not Encrypted)')),
                    DropdownMenuItem(value: 'flexible', child: Text('Flexible')),
                  ],
                  dropdownColor: AppColors.surfaceContainerHigh,
                  style: const TextStyle(color: AppColors.onSurface),
                  onChanged: (val) {
                    if (val != null) setState(() => _encryptionMode = val);
                  },
                  onSaved: (val) {
                    if (val != null) _encryptionMode = val;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _maxUses,
                  decoration: const InputDecoration(labelText: 'Max Uses'),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    if (int.tryParse(val) == null) return 'Must be a number';
                    if (int.parse(val) < 1) return 'Must be >= 1';
                    return null;
                  },
                  style: const TextStyle(color: AppColors.onSurface),
                  onSaved: (val) => _maxUses = val ?? '1',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _bonusAmountGB,
                        decoration: const InputDecoration(
                          labelText: 'Storage Bonus (GB)',
                        ),
                        keyboardType: TextInputType.number,
                        enabled: !_isLimitless,
                        validator: !_isLimitless ? (val) {
                          if (val == null || val.isEmpty) return 'Required';
                          if (double.tryParse(val) == null) return 'Must be a number';
                          return null;
                        } : null,
                        style: const TextStyle(color: AppColors.onSurface),
                        onSaved: (val) => _bonusAmountGB = val ?? '0',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        const Text('Limitless', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                        Switch(
                          value: _isLimitless,
                          onChanged: (val) {
                            setState(() {
                              _isLimitless = val;
                            });
                          },
                          activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                          activeThumbColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: AppColors.onSurfaceVariant)),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimaryContainer,
          ),
          child: Text(isEdit ? 'Update' : 'Create'),
        ),
      ],
    );
  }
}

class InvitationCode {
  final String id;
  final String code;
  final String type;
  final String encryptionMode;
  final String? encryptionKey;
  final int? storageLimit;
  final int usedCount;
  final int maxUses;
  final bool isRevoked;
  final String? assignedBotToken;
  final String? assignedChatId;
  final DateTime createdAt;

  InvitationCode({
    required this.id,
    required this.code,
    required this.type,
    required this.encryptionMode,
    this.encryptionKey,
    this.storageLimit,
    required this.usedCount,
    required this.maxUses,
    required this.isRevoked,
    this.assignedBotToken,
    this.assignedChatId,
    required this.createdAt,
  });

  factory InvitationCode.fromJson(Map<String, dynamic> json) {
    return InvitationCode(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      type: json['type'] as String? ?? '',
      encryptionMode: json['encryptionMode'] as String? ?? '',
      encryptionKey: json['encryptionKey'] as String?,
      storageLimit: json['storageLimit'] as int?,
      usedCount: json['usedCount'] as int? ?? 0,
      maxUses: json['maxUses'] as int? ?? 1,
      isRevoked: json['isRevoked'] as bool? ?? false,
      assignedBotToken: json['assignedBotToken'] as String?,
      assignedChatId: json['assignedChatId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'type': type,
      'encryptionMode': encryptionMode,
      'encryptionKey': encryptionKey,
      'storageLimit': storageLimit,
      'usedCount': usedCount,
      'maxUses': maxUses,
      'isRevoked': isRevoked,
      'assignedBotToken': assignedBotToken,
      'assignedChatId': assignedChatId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

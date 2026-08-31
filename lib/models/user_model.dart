class User {
  final String id;
  final String username;
  final String displayName;
  final String? email;
  final String? encryptionMode;
  final String? telegramNodeId;
  final String? invitationCodeUsed;
  final String? googleId;
  final int storageUsed;
  final int storageLimit;
  final int baseStorage;
  final int invitationBonusStorage;
  final int customStorageBonus;
  final bool isSuspended;
  final bool isActive;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    this.email,
    this.encryptionMode,
    this.telegramNodeId,
    this.invitationCodeUsed,
    this.googleId,
    required this.storageUsed,
    required this.storageLimit,
    required this.baseStorage,
    required this.invitationBonusStorage,
    required this.customStorageBonus,
    required this.isSuspended,
    required this.isActive,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      displayName: json['displayName'] ?? '',
      email: json['email'],
      encryptionMode: json['encryptionMode'],
      telegramNodeId: json['telegramNodeId'],
      invitationCodeUsed: json['invitationCodeUsed'],
      googleId: json['googleId'],
      storageUsed: json['storageUsed'] ?? 0,
      storageLimit: json['storageLimit'] ?? 0,
      baseStorage: json['baseStorage'] ?? 0,
      invitationBonusStorage: json['invitationBonusStorage'] ?? 0,
      customStorageBonus: json['customStorageBonus'] ?? 0,
      isSuspended: json['isSuspended'] ?? false,
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'email': email,
      'encryptionMode': encryptionMode,
      'telegramNodeId': telegramNodeId,
      'invitationCodeUsed': invitationCodeUsed,
      'googleId': googleId,
      'storageUsed': storageUsed,
      'storageLimit': storageLimit,
      'baseStorage': baseStorage,
      'invitationBonusStorage': invitationBonusStorage,
      'customStorageBonus': customStorageBonus,
      'isSuspended': isSuspended,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

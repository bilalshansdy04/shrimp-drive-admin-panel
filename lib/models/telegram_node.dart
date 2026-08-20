class TelegramNode {
  final String id;
  final String name;
  final String botToken;
  final String chatId;
  final bool isActive;
  final DateTime? createdAt;

  TelegramNode({
    required this.id,
    required this.name,
    required this.botToken,
    required this.chatId,
    this.isActive = true,
    this.createdAt,
  });

  factory TelegramNode.fromJson(Map<String, dynamic> json) {
    return TelegramNode(
      id: json['id'],
      name: json['name'],
      botToken: json['botToken'] ?? json['bot_token'], // handle both snake/camel
      chatId: json['chatId'] ?? json['chat_id'],
      isActive: json['isActive'] ?? json['is_active'] ?? true,
      createdAt: json['createdAt'] != null || json['created_at'] != null 
          ? DateTime.parse(json['createdAt'] ?? json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'botToken': botToken,
      'chatId': chatId,
      'isActive': isActive,
    };
  }
}

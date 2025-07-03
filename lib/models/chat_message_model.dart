class ChatMessage {
  final String id;
  final String sender;
  final String? text;
  final String? voiceUrl;
  final String timestamp;

  ChatMessage({
    required this.id,
    required this.sender,
    this.text,
    this.voiceUrl,
    required this.timestamp,
  });
}

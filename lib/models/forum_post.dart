class ForumPost {
  final String id;
  final String user;
  final String timestamp;
  final String topic;
  final String lastMessage;
  final int messagesCount;
  final bool voiceSupport;

  ForumPost({
    required this.id,
    required this.user,
    required this.timestamp,
    required this.topic,
    required this.lastMessage,
    required this.messagesCount,
    this.voiceSupport = false,
  });
}

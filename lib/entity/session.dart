class Session {
  final String sessionId;
  final String title;
  final String userId;
  final int robotId;
  final String message;

  Session(
      {required this.sessionId,
      required this.title,
      required this.userId,
      required this.robotId,
      required this.message});

  @override
  String toString() {
    // 调试的时候使用
    return 'Session{sessionId: $sessionId, title: $title, userId: $userId, robotId: $robotId, message: $message}';
  }
}

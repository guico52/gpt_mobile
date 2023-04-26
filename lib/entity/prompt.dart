class Prompt {
  String id;
  String title;
  String content;

  Prompt({
    required this.id,
    required this.title,
    required this.content,
  });

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'title': title,
      'content': content,
    };
  }
}
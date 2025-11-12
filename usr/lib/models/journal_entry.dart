class JournalEntry {
  final String id;
  final String userId;
  final String title;
  final String content;
  final DateTime createdAt;
  final MoodLevel mood;
  final List<String> tags;
  final bool isLocked; // Premium feature

  JournalEntry({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.mood,
    this.tags = const [],
    this.isLocked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'mood': mood.index,
      'tags': tags,
      'isLocked': isLocked,
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      mood: MoodLevel.values[json['mood']],
      tags: List<String>.from(json['tags'] ?? []),
      isLocked: json['isLocked'] ?? false,
    );
  }
}

enum MoodLevel {
  veryBad,
  bad,
  neutral,
  good,
  great,
}

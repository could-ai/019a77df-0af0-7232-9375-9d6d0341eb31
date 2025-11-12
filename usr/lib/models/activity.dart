class Activity {
  final String id;
  final String title;
  final String description;
  final ActivityCategory category;
  final int durationMinutes;
  final bool isPremium;
  final String iconName;
  final List<String> benefits;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.durationMinutes,
    this.isPremium = false,
    required this.iconName,
    this.benefits = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.index,
      'durationMinutes': durationMinutes,
      'isPremium': isPremium,
      'iconName': iconName,
      'benefits': benefits,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: ActivityCategory.values[json['category']],
      durationMinutes: json['durationMinutes'],
      isPremium: json['isPremium'] ?? false,
      iconName: json['iconName'],
      benefits: List<String>.from(json['benefits'] ?? []),
    );
  }
}

enum ActivityCategory {
  physical,
  creative,
  social,
  mindfulness,
  learning,
  selfCare,
}

class CompletedActivity {
  final String id;
  final String userId;
  final String activityId;
  final DateTime completedAt;
  final String? notes;

  CompletedActivity({
    required this.id,
    required this.userId,
    required this.activityId,
    required this.completedAt,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'activityId': activityId,
      'completedAt': completedAt.toIso8601String(),
      'notes': notes,
    };
  }

  factory CompletedActivity.fromJson(Map<String, dynamic> json) {
    return CompletedActivity(
      id: json['id'],
      userId: json['userId'],
      activityId: json['activityId'],
      completedAt: DateTime.parse(json['completedAt']),
      notes: json['notes'],
    );
  }
}

class Meditation {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final MeditationType type;
  final bool isPremium;
  final String audioUrl;
  final String imageUrl;

  Meditation({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.type,
    this.isPremium = false,
    required this.audioUrl,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'durationMinutes': durationMinutes,
      'type': type.index,
      'isPremium': isPremium,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
    };
  }

  factory Meditation.fromJson(Map<String, dynamic> json) {
    return Meditation(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      durationMinutes: json['durationMinutes'],
      type: MeditationType.values[json['type']],
      isPremium: json['isPremium'] ?? false,
      audioUrl: json['audioUrl'],
      imageUrl: json['imageUrl'],
    );
  }
}

enum MeditationType {
  guided,
  breathing,
  visualization,
  bodycan,
  loving kindness,
  healing,
}

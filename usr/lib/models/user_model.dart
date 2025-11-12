class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isPremium;
  final DateTime? premiumExpiryDate;
  final DateTime breakupDate;
  final int daysHealing;
  final String? partnerName;
  final int journalEntries;
  final int completedActivities;
  final int meditationMinutes;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.isPremium = false,
    this.premiumExpiryDate,
    required this.breakupDate,
    this.partnerName,
    this.journalEntries = 0,
    this.completedActivities = 0,
    this.meditationMinutes = 0,
  }) : daysHealing = DateTime.now().difference(breakupDate).inDays;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isPremium': isPremium,
      'premiumExpiryDate': premiumExpiryDate?.toIso8601String(),
      'breakupDate': breakupDate.toIso8601String(),
      'partnerName': partnerName,
      'journalEntries': journalEntries,
      'completedActivities': completedActivities,
      'meditationMinutes': meditationMinutes,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isPremium: json['isPremium'] ?? false,
      premiumExpiryDate: json['premiumExpiryDate'] != null
          ? DateTime.parse(json['premiumExpiryDate'])
          : null,
      breakupDate: DateTime.parse(json['breakupDate']),
      partnerName: json['partnerName'],
      journalEntries: json['journalEntries'] ?? 0,
      completedActivities: json['completedActivities'] ?? 0,
      meditationMinutes: json['meditationMinutes'] ?? 0,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? isPremium,
    DateTime? premiumExpiryDate,
    DateTime? breakupDate,
    String? partnerName,
    int? journalEntries,
    int? completedActivities,
    int? meditationMinutes,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiryDate: premiumExpiryDate ?? this.premiumExpiryDate,
      breakupDate: breakupDate ?? this.breakupDate,
      partnerName: partnerName ?? this.partnerName,
      journalEntries: journalEntries ?? this.journalEntries,
      completedActivities: completedActivities ?? this.completedActivities,
      meditationMinutes: meditationMinutes ?? this.meditationMinutes,
    );
  }
}

import '../models/activity.dart';

class ActivityService {
  static final ActivityService _instance = ActivityService._internal();
  factory ActivityService() => _instance;
  ActivityService._internal();

  final List<Activity> _activities = [
    Activity(
      id: 'act_001',
      title: 'Caminhada ao ar livre',
      description: 'Uma caminhada de 30 minutos pode melhorar significativamente seu humor e reduzir o estresse.',
      category: ActivityCategory.physical,
      durationMinutes: 30,
      isPremium: false,
      iconName: 'directions_walk',
      benefits: ['Reduz estresse', 'Melhora humor', 'Aumenta energia'],
    ),
    Activity(
      id: 'act_002',
      title: 'Diário de gratidão',
      description: 'Escreva 3 coisas pelas quais você é grato hoje.',
      category: ActivityCategory.mindfulness,
      durationMinutes: 10,
      isPremium: false,
      iconName: 'favorite',
      benefits: ['Aumenta positividade', 'Melhora perspectiva', 'Reduz ansiedade'],
    ),
    Activity(
      id: 'act_003',
      title: 'Arte terapêutica',
      description: 'Expresse seus sentimentos através de pintura, desenho ou colagem.',
      category: ActivityCategory.creative,
      durationMinutes: 45,
      isPremium: true,
      iconName: 'palette',
      benefits: ['Libera emoções', 'Aumenta criatividade', 'Promove autoconsciência'],
    ),
    Activity(
      id: 'act_004',
      title: 'Café com amigo',
      description: 'Conecte-se com alguém que se importa com você.',
      category: ActivityCategory.social,
      durationMinutes: 60,
      isPremium: false,
      iconName: 'people',
      benefits: ['Reduz solidão', 'Aumenta suporte social', 'Melhora humor'],
    ),
    Activity(
      id: 'act_005',
      title: 'Ioga restaurativa',
      description: 'Sessão suave de ioga focada em relaxamento e cura.',
      category: ActivityCategory.physical,
      durationMinutes: 40,
      isPremium: true,
      iconName: 'self_improvement',
      benefits: ['Reduz tensão', 'Melhora flexibilidade', 'Promove paz interior'],
    ),
    Activity(
      id: 'act_006',
      title: 'Curso online de autodesenvolvimento',
      description: 'Aprenda novas habilidades e invista em seu crescimento pessoal.',
      category: ActivityCategory.learning,
      durationMinutes: 120,
      isPremium: true,
      iconName: 'school',
      benefits: ['Aumenta autoconfiança', 'Expande conhecimento', 'Foca no futuro'],
    ),
    Activity(
      id: 'act_007',
      title: 'Spa em casa',
      description: 'Crie um ambiente relaxante com banho quente, máscaras faciais e autocuidado.',
      category: ActivityCategory.selfCare,
      durationMinutes: 90,
      isPremium: true,
      iconName: 'spa',
      benefits: ['Promove relaxamento', 'Melhora autoestima', 'Reduz estresse'],
    ),
    Activity(
      id: 'act_008',
      title: 'Exercícios de respiração',
      description: 'Técnicas simples de respiração para acalmar a mente.',
      category: ActivityCategory.mindfulness,
      durationMinutes: 5,
      isPremium: false,
      iconName: 'air',
      benefits: ['Reduz ansiedade', 'Melhora foco', 'Acalma sistema nervoso'],
    ),
  ];

  final List<CompletedActivity> _completedActivities = [];

  List<Activity> getAllActivities() => List.unmodifiable(_activities);

  List<Activity> getActivitiesByCategory(ActivityCategory category) {
    return _activities.where((act) => act.category == category).toList();
  }

  List<Activity> getFreeActivities() {
    return _activities.where((act) => !act.isPremium).toList();
  }

  List<Activity> getPremiumActivities() {
    return _activities.where((act) => act.isPremium).toList();
  }

  Activity? getActivityById(String id) {
    try {
      return _activities.firstWhere((act) => act.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> completeActivity(CompletedActivity completed) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _completedActivities.add(completed);
  }

  List<CompletedActivity> getUserCompletedActivities(String userId) {
    return _completedActivities
        .where((comp) => comp.userId == userId)
        .toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
  }

  int getCompletedCountByCategory(String userId, ActivityCategory category) {
    final completed = getUserCompletedActivities(userId);
    return completed.where((comp) {
      final activity = getActivityById(comp.activityId);
      return activity?.category == category;
    }).length;
  }
}

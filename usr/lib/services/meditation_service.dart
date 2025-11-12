import '../models/meditation.dart';

class MeditationService {
  static final MeditationService _instance = MeditationService._internal();
  factory MeditationService() => _instance;
  MeditationService._internal();

  final List<Meditation> _meditations = [
    Meditation(
      id: 'med_001',
      title: 'Cura do Coração Partido',
      description: 'Uma meditação guiada para curar as feridas emocionais e encontrar paz interior.',
      durationMinutes: 15,
      type: MeditationType.guided,
      isPremium: false,
      audioUrl: 'assets/audio/healing_heart.mp3',
      imageUrl: 'assets/images/meditation_heart.jpg',
    ),
    Meditation(
      id: 'med_002',
      title: 'Respiração 4-7-8',
      description: 'Técnica de respiração poderosa para acalmar ansiedade e promover relaxamento.',
      durationMinutes: 5,
      type: MeditationType.breathing,
      isPremium: false,
      audioUrl: 'assets/audio/breathing_478.mp3',
      imageUrl: 'assets/images/meditation_breathing.jpg',
    ),
    Meditation(
      id: 'med_003',
      title: 'Visualização do Futuro Feliz',
      description: 'Imagine seu futuro brilhante e cheio de possibilidades.',
      durationMinutes: 20,
      type: MeditationType.visualization,
      isPremium: true,
      audioUrl: 'assets/audio/happy_future.mp3',
      imageUrl: 'assets/images/meditation_future.jpg',
    ),
    Meditation(
      id: 'med_004',
      title: 'Escaneamento Corporal',
      description: 'Libere a tensão física causada pelo estresse emocional.',
      durationMinutes: 25,
      type: MeditationType.bodycan,
      isPremium: true,
      audioUrl: 'assets/audio/body_scan.mp3',
      imageUrl: 'assets/images/meditation_body.jpg',
    ),
    Meditation(
      id: 'med_005',
      title: 'Amor Próprio e Compaixão',
      description: 'Cultive amor incondicional por si mesmo durante este momento difícil.',
      durationMinutes: 18,
      type: MeditationType.lovingKindness,
      isPremium: true,
      audioUrl: 'assets/audio/self_love.mp3',
      imageUrl: 'assets/images/meditation_love.jpg',
    ),
    Meditation(
      id: 'med_006',
      title: 'Liberação Emocional',
      description: 'Permita-se sentir e liberar emoções reprimidas de forma saudável.',
      durationMinutes: 30,
      type: MeditationType.healing,
      isPremium: true,
      audioUrl: 'assets/audio/emotional_release.mp3',
      imageUrl: 'assets/images/meditation_release.jpg',
    ),
    Meditation(
      id: 'med_007',
      title: 'Meditação Matinal de Força',
      description: 'Comece seu dia com energia positiva e determinação.',
      durationMinutes: 10,
      type: MeditationType.guided,
      isPremium: false,
      audioUrl: 'assets/audio/morning_strength.mp3',
      imageUrl: 'assets/images/meditation_morning.jpg',
    ),
  ];

  List<Meditation> getAllMeditations() => List.unmodifiable(_meditations);

  List<Meditation> getFreeMeditations() {
    return _meditations.where((med) => !med.isPremium).toList();
  }

  List<Meditation> getPremiumMeditations() {
    return _meditations.where((med) => med.isPremium).toList();
  }

  List<Meditation> getMeditationsByType(MeditationType type) {
    return _meditations.where((med) => med.type == type).toList();
  }

  Meditation? getMeditationById(String id) {
    try {
      return _meditations.firstWhere((med) => med.id == id);
    } catch (e) {
      return null;
    }
  }
}

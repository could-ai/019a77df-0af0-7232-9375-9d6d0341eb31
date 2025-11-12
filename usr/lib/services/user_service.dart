import '../models/user_model.dart';

class UserService {
  // Singleton pattern
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  // Mock user data (in production, this would connect to Supabase)
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  bool get isPremium => _currentUser?.isPremium ?? false;

  Future<void> initializeUser() async {
    // Mock user initialization
    await Future.delayed(const Duration(seconds: 2));
    _currentUser = UserModel(
      id: 'user_001',
      name: 'Maria Silva',
      email: 'maria@example.com',
      isPremium: false,
      breakupDate: DateTime.now().subtract(const Duration(days: 15)),
      partnerName: null,
      journalEntries: 5,
      completedActivities: 12,
      meditationMinutes: 45,
    );
  }

  Future<bool> upgradeToPremium() async {
    // Mock premium upgrade (in production, integrate with payment processor)
    await Future.delayed(const Duration(seconds: 1));
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        isPremium: true,
        premiumExpiryDate: DateTime.now().add(const Duration(days: 365)),
      );
      return true;
    }
    return false;
  }

  Future<void> updateProfile({
    String? name,
    String? partnerName,
    DateTime? breakupDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        partnerName: partnerName,
        breakupDate: breakupDate,
      );
    }
  }

  Future<void> incrementJournalEntries() async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        journalEntries: _currentUser!.journalEntries + 1,
      );
    }
  }

  Future<void> incrementCompletedActivities() async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        completedActivities: _currentUser!.completedActivities + 1,
      );
    }
  }

  Future<void> addMeditationMinutes(int minutes) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        meditationMinutes: _currentUser!.meditationMinutes + minutes,
      );
    }
  }

  void logout() {
    _currentUser = null;
  }
}

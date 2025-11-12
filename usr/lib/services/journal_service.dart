import '../models/journal_entry.dart';
import '../models/user_model.dart';

class JournalService {
  static final JournalService _instance = JournalService._internal();
  factory JournalService() => _instance;
  JournalService._internal();

  final List<JournalEntry> _entries = [];

  List<JournalEntry> getEntries(String userId) {
    return _entries.where((entry) => entry.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> addEntry(JournalEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _entries.add(entry);
  }

  Future<void> updateEntry(JournalEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
    }
  }

  Future<void> deleteEntry(String entryId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _entries.removeWhere((entry) => entry.id == entryId);
  }

  JournalEntry? getEntryById(String entryId) {
    try {
      return _entries.firstWhere((entry) => entry.id == entryId);
    } catch (e) {
      return null;
    }
  }

  List<JournalEntry> getEntriesByMood(String userId, MoodLevel mood) {
    return _entries
        .where((entry) => entry.userId == userId && entry.mood == mood)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Map<MoodLevel, int> getMoodStatistics(String userId) {
    final userEntries = _entries.where((entry) => entry.userId == userId);
    final stats = <MoodLevel, int>{};
    
    for (var mood in MoodLevel.values) {
      stats[mood] = userEntries.where((entry) => entry.mood == mood).length;
    }
    
    return stats;
  }
}

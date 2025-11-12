import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../services/journal_service.dart';
import '../services/user_service.dart';
import 'package:intl/intl.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> with SingleTickerProviderStateMixin {
  final JournalService _journalService = JournalService();
  final UserService _userService = UserService();
  late TabController _tabController;
  MoodLevel? _filterMood;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = _userService.currentUser?.id ?? '';
    final entries = _filterMood == null
        ? _journalService.getEntries(userId)
        : _journalService.getEntriesByMood(userId, _filterMood!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Diário de Cura'),
        actions: [
          IconButton(
            icon: const Icon(Icons.insert_chart_outlined),
            tooltip: 'Estatísticas de Humor',
            onPressed: () => _showMoodStatistics(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          onTap: (index) {
            setState(() {
              _filterMood = index == 0 ? null : MoodLevel.values[index - 1];
            });
          },
          tabs: const [
            Tab(text: 'Todos'),
            Tab(text: '😢 Muito Mal'),
            Tab(text: '😔 Mal'),
            Tab(text: '😐 Neutro'),
            Tab(text: '🙂 Bem'),
            Tab(text: '😄 Ótimo'),
          ],
        ),
      ),
      body: entries.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return _buildJournalCard(entries[index]);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEntryDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nova Entrada'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_stories_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'Nenhuma entrada ainda',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comece a escrever seus pensamentos e sentimentos',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalCard(JournalEntry entry) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showEntryDetails(context, entry),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _getMoodIcon(entry.mood),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy - HH:mm').format(entry.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (entry.isLocked)
                    Icon(Icons.lock, size: 20, color: Colors.amber[700]),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showEntryOptions(context, entry),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                entry.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700]),
              ),
              if (entry.tags.isNotEmpty) ..[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: entry.tags.map((tag) => Chip(
                    label: Text(tag, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _getMoodIcon(MoodLevel mood) {
    IconData icon;
    Color color;
    
    switch (mood) {
      case MoodLevel.veryBad:
        icon = Icons.sentiment_very_dissatisfied;
        color = Colors.red;
        break;
      case MoodLevel.bad:
        icon = Icons.sentiment_dissatisfied;
        color = Colors.orange;
        break;
      case MoodLevel.neutral:
        icon = Icons.sentiment_neutral;
        color = Colors.amber;
        break;
      case MoodLevel.good:
        icon = Icons.sentiment_satisfied;
        color = Colors.lightGreen;
        break;
      case MoodLevel.great:
        icon = Icons.sentiment_very_satisfied;
        color = Colors.green;
        break;
    }
    
    return Icon(icon, color: color, size: 32);
  }

  void _showAddEntryDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    MoodLevel selectedMood = MoodLevel.neutral;
    final tags = <String>[];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nova Entrada no Diário'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'O que você está sentindo?',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Como você está se sentindo?', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: MoodLevel.values.map((mood) {
                    return ChoiceChip(
                      label: Text(_getMoodLabel(mood)),
                      selected: selectedMood == mood,
                      onSelected: (selected) {
                        setDialogState(() {
                          selectedMood = mood;
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                  final entry = JournalEntry(
                    id: 'entry_${DateTime.now().millisecondsSinceEpoch}',
                    userId: _userService.currentUser?.id ?? '',
                    title: titleController.text,
                    content: contentController.text,
                    createdAt: DateTime.now(),
                    mood: selectedMood,
                    tags: tags,
                  );
                  await _journalService.addEntry(entry);
                  await _userService.incrementJournalEntries();
                  if (context.mounted) {
                    Navigator.pop(context);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Entrada salva com sucesso!')),
                    );
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  String _getMoodLabel(MoodLevel mood) {
    switch (mood) {
      case MoodLevel.veryBad:
        return '😢 Muito Mal';
      case MoodLevel.bad:
        return '😔 Mal';
      case MoodLevel.neutral:
        return '😐 Neutro';
      case MoodLevel.good:
        return '🙂 Bem';
      case MoodLevel.great:
        return '😄 Ótimo';
    }
  }

  void _showEntryDetails(BuildContext context, JournalEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            _getMoodIcon(entry.mood),
            const SizedBox(width: 12),
            Expanded(child: Text(entry.title)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(entry.createdAt),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 16),
              Text(entry.content),
              if (entry.tags.isNotEmpty) ..[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: entry.tags.map((tag) => Chip(label: Text(tag))).toList(),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showEntryOptions(BuildContext context, JournalEntry entry) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement edit
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Excluir', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await _journalService.deleteEntry(entry.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Entrada excluída')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMoodStatistics(BuildContext context) {
    final stats = _journalService.getMoodStatistics(_userService.currentUser?.id ?? '');
    final total = stats.values.fold(0, (sum, count) => sum + count);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Estatísticas de Humor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: MoodLevel.values.map((mood) {
            final count = stats[mood] ?? 0;
            final percentage = total > 0 ? (count / total * 100).toStringAsFixed(1) : '0';
            return ListTile(
              leading: _getMoodIcon(mood),
              title: Text(_getMoodLabel(mood)),
              trailing: Text('$count ($percentage%)', style: const TextStyle(fontWeight: FontWeight.bold)),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
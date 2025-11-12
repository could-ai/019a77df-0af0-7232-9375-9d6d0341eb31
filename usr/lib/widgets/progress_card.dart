import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final int daysHealing;
  final int journalEntries;
  final int activitiesCompleted;
  final int meditationMinutes;

  const ProgressCard({
    super.key,
    required this.daysHealing,
    required this.journalEntries,
    required this.activitiesCompleted,
    required this.meditationMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seu Progresso de Cura',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(context, 'Dias', daysHealing.toString(),
                    Icons.calendar_today),
                _buildStat(context, 'Diários', journalEntries.toString(),
                    Icons.auto_stories),
                _buildStat(context, 'Atividades',
                    activitiesCompleted.toString(), Icons.favorite),
                _buildStat(context, 'Minutos', meditationMinutes.toString(),
                    Icons.self_improvement),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
      BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

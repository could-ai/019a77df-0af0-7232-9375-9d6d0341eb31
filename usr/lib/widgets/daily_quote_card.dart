import 'package:flutter/material.dart';

class DailyQuoteCard extends StatelessWidget {
  const DailyQuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app, this would fetch a random quote
    const quote = '"A ferida é o lugar por onde a luz entra em você."';
    const author = '- Rumi';

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.format_quote,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              quote,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              author,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../services/activity_service.dart';
import '../services/user_service.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final ActivityService _activityService = ActivityService();
  final UserService _userService = UserService();
  ActivityCategory? _selectedCategory;
  bool _showOnlyFree = false;

  @override
  Widget build(BuildContext context) {
    List<Activity> activities;
    
    if (_selectedCategory != null) {
      activities = _activityService.getActivitiesByCategory(_selectedCategory!);
    } else if (_showOnlyFree) {
      activities = _activityService.getFreeActivities();
    } else {
      activities = _activityService.getAllActivities();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atividades de Cura'),
        actions: [
          IconButton(
            icon: Icon(_showOnlyFree ? Icons.filter_alt : Icons.filter_alt_outlined),
            tooltip: 'Mostrar apenas gratuitas',
            onPressed: () {
              setState(() {
                _showOnlyFree = !_showOnlyFree;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Histórico',
            onPressed: () => _showHistory(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: activities.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      return _buildActivityCard(activities[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildCategoryChip('Todos', null, Icons.apps),
          ...ActivityCategory.values.map((category) {
            return _buildCategoryChip(
              _getCategoryName(category),
              category,
              _getCategoryIcon(category),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, ActivityCategory? category, IconData icon) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'Nenhuma atividade encontrada',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Activity activity) {
    final isPremium = activity.isPremium;
    final userIsPremium = _userService.isPremium;
    final isLocked = isPremium && !userIsPremium;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => isLocked
            ? _showPremiumDialog(context)
            : _showActivityDetails(context, activity),
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(activity.category).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getCategoryIcon(activity.category),
                          color: _getCategoryColor(activity.category),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  '${activity.durationMinutes} min',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(activity.category).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _getCategoryName(activity.category),
                                    style: TextStyle(
                                      color: _getCategoryColor(activity.category),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (isPremium)
                        Icon(
                          Icons.workspace_premium,
                          color: Colors.amber[700],
                          size: 28,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    activity.description,
                    style: TextStyle(color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: activity.benefits.take(3).map((benefit) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Text(
                          benefit,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green[700],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            if (isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.lock,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showActivityDetails(BuildContext context, Activity activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(activity.category).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _getCategoryIcon(activity.category),
                            color: _getCategoryColor(activity.category),
                            size: 40,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${activity.durationMinutes} minutos',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Descrição',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      activity.description,
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Benefícios',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ...activity.benefits.map((benefit) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  benefit,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final completed = CompletedActivity(
                            id: 'comp_${DateTime.now().millisecondsSinceEpoch}',
                            userId: _userService.currentUser?.id ?? '',
                            activityId: activity.id,
                            completedAt: DateTime.now(),
                          );
                          await _activityService.completeActivity(completed);
                          await _userService.incrementCompletedActivities();
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Atividade concluída! Continue assim! 🎉'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Marcar como Concluída', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.workspace_premium, color: Colors.amber[700]),
            const SizedBox(width: 8),
            const Text('Conteúdo Premium'),
          ],
        ),
        content: const Text(
          'Esta atividade está disponível apenas para assinantes Premium. Faça upgrade para desbloquear todo o conteúdo!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/premium');
            },
            child: const Text('Ver Planos'),
          ),
        ],
      ),
    );
  }

  void _showHistory(BuildContext context) {
    final completed = _activityService.getUserCompletedActivities(
      _userService.currentUser?.id ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Histórico de Atividades',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: completed.isEmpty
                  ? const Center(child: Text('Nenhuma atividade concluída ainda'))
                  : ListView.builder(
                      itemCount: completed.length,
                      itemBuilder: (context, index) {
                        final comp = completed[index];
                        final activity = _activityService.getActivityById(comp.activityId);
                        return ListTile(
                          leading: Icon(_getCategoryIcon(activity?.category ?? ActivityCategory.mindfulness)),
                          title: Text(activity?.title ?? 'Atividade'),
                          subtitle: Text('Concluída em ${comp.completedAt.day}/${comp.completedAt.month}/${comp.completedAt.year}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.physical:
        return 'Físico';
      case ActivityCategory.creative:
        return 'Criativo';
      case ActivityCategory.social:
        return 'Social';
      case ActivityCategory.mindfulness:
        return 'Mindfulness';
      case ActivityCategory.learning:
        return 'Aprendizado';
      case ActivityCategory.selfCare:
        return 'Autocuidado';
    }
  }

  IconData _getCategoryIcon(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.physical:
        return Icons.directions_run;
      case ActivityCategory.creative:
        return Icons.palette;
      case ActivityCategory.social:
        return Icons.people;
      case ActivityCategory.mindfulness:
        return Icons.self_improvement;
      case ActivityCategory.learning:
        return Icons.school;
      case ActivityCategory.selfCare:
        return Icons.spa;
    }
  }

  Color _getCategoryColor(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.physical:
        return Colors.blue;
      case ActivityCategory.creative:
        return Colors.purple;
      case ActivityCategory.social:
        return Colors.orange;
      case ActivityCategory.mindfulness:
        return Colors.green;
      case ActivityCategory.learning:
        return Colors.indigo;
      case ActivityCategory.selfCare:
        return Colors.pink;
    }
  }
}
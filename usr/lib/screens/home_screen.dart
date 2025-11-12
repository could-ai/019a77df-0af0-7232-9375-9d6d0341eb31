import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../widgets/premium_banner.dart';
import '../widgets/progress_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/daily_quote_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final UserService _userService = UserService();

  final List<Widget> _screens = [
    const HomeContent(),
    const Placeholder(), // Journal screen navigation
    const Placeholder(), // Activities screen navigation
    const Placeholder(), // Profile screen navigation
  ];

  @override
  Widget build(BuildContext context) {
    final user = _userService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${user?.name ?? "Usuário"}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/journal');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/activities');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profile');
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories),
            label: 'Diário',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Atividades',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    final user = userService.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!userService.isPremium) const PremiumBanner(),
          const SizedBox(height: 16),
          ProgressCard(
            daysHealing: user?.daysHealing ?? 0,
            journalEntries: user?.journalEntries ?? 0,
            activitiesCompleted: user?.completedActivities ?? 0,
            meditationMinutes: user?.meditationMinutes ?? 0,
          ),
          const SizedBox(height: 24),
          const DailyQuoteCard(),
          const SizedBox(height: 24),
          Text(
            'Ações Rápidas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              QuickActionCard(
                icon: Icons.auto_stories,
                title: 'Escrever no Diário',
                color: Colors.blue,
                onTap: () => Navigator.pushNamed(context, '/journal'),
              ),
              QuickActionCard(
                icon: Icons.self_improvement,
                title: 'Meditar',
                color: Colors.purple,
                onTap: () => Navigator.pushNamed(context, '/meditation'),
              ),
              QuickActionCard(
                icon: Icons.favorite,
                title: 'Atividades',
                color: Colors.pink,
                onTap: () => Navigator.pushNamed(context, '/activities'),
              ),
              QuickActionCard(
                icon: Icons.groups,
                title: 'Comunidade',
                color: Colors.orange,
                onTap: () => Navigator.pushNamed(context, '/community'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

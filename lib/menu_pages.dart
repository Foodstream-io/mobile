import 'package:flutter/material.dart';
import 'pages/live_streaming_page.dart';

class NavigationDestination {
  final IconData icon;
  final IconData? selectedIcon; // Add this
  final String label;

  NavigationDestination({
    required this.icon,
    this.selectedIcon, // Make it optional
    required this.label,
  });
}

/// Page displaying menu items/dishes available in the application.
class PlatsPage extends StatelessWidget {
  const PlatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Plats Page'));
  }
}

/// Page displaying the user's favorite items.
class FavorisPage extends StatelessWidget {
  const FavorisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Favoris Page'));
  }
}

/// Help and support page with user guidance.
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Help Page'));
  }
}

/// User profile page displaying account information.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Page'));
  }
}
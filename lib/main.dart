import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import 'drawer.dart';
import 'menu_pages.dart' as menu_pages;
import 'pages/home_page.dart';
import 'login.dart';
import 'bottom_navigation_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) { 
    return MaterialApp(
      title: 'FoodStream',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: _isLoggedIn
        ? _buildMainScaffold()
        : LoginPage(onLoginSuccess: _onLoginSuccess),
    );
  }

  Widget _getPageForIndex(int index) {
    switch (index) {
      case 0: return const menu_pages.PlatsPage();
      case 1: return const menu_pages.FavorisPage();
      case 2: return const HomePage();
      case 3: return const menu_pages.HelpPage();
      case 4: return const menu_pages.ProfilePage();
      default: return const SizedBox.shrink();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (kDebugMode) {
      print('Tapped on $index');
    }
  }

  void _onLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  Widget _buildMainScaffold() {
    return Scaffold(
      drawer: const AppDrawer(),
      bottomNavigationBar: AppNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.restaurant_menu_outlined),
            selectedIcon: const Icon(Icons.restaurant_menu),
            label: 'Plats',
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_border),
            selectedIcon: const Icon(Icons.favorite),
            label: 'Favoris',
          ),
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.help_outline),
            selectedIcon: const Icon(Icons.help),
            label: 'Help',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('FoodStream'),
        centerTitle: true,
      ),
      body: _getPageForIndex(_selectedIndex),
    );
  }
}

import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 240, 238, 238),
      currentIndex: selectedIndex,
      onTap: onDestinationSelected,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.black,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: _buildNavigationBarItems(context),
      selectedLabelStyle: const TextStyle(fontSize: 12, color: Colors.orange),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        color: Colors.blueGrey,
      ),
    );
  }

  /// Builds the navigation bar items based on the provided [destinations].
  List<BottomNavigationBarItem> _buildNavigationBarItems(BuildContext context) {
    return destinations.asMap().entries.map((entry) {
      final index = entry.key;
      final destination = entry.value;
      final isSelected = index == selectedIndex;

      return BottomNavigationBarItem(
        icon: _buildAnimatedIcon(destination, isSelected, context),
        label: destination.label,
      );
    }).toList();
  }

  /// Builds an animated icon for the given [destination].
  Widget _buildAnimatedIcon(NavigationDestination destination, bool isSelected, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange.withAlpha((0.1 * 255).round()) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Icon(
          isSelected && destination.selectedIcon != null
              ? (destination.selectedIcon as Icon).icon
              : (destination.icon as Icon).icon,
          key: ValueKey<bool>(isSelected),
          color: isSelected ? Colors.orange : Colors.grey,
          size: isSelected ? 26 : 24,
        ),
      ),
    );
  }
}

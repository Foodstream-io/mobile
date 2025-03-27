import 'package:flutter/material.dart';

/// A customized drawer widget with search field and menu items.
///
/// This drawer provides a sleek black background with white text and icons,
/// a search field at the top, and customizable menu items.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.black,
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const DrawerSearchField(),
                  const SizedBox(height: 12),
                  DrawerMenuItem(
                    text: 'Friends',
                    icon: Icons.people,
                    onClicked: () => _navigateToPage(context, 0),
                  ),
                  const SizedBox(height: 5),
                  DrawerMenuItem(
                    text: 'Liked Photos',
                    icon: Icons.favorite_border,
                    onClicked: () => _navigateToPage(context, 1),
                  ),
                  const SizedBox(height: 5),
                  DrawerMenuItem(
                    text: 'Workflow',
                    icon: Icons.workspaces_outline,
                    onClicked: () => _navigateToPage(context, 2),
                  ),
                  const SizedBox(height: 5),
                  DrawerMenuItem(
                    text: 'Updates',
                    icon: Icons.update,
                    onClicked: () => _navigateToPage(context, 3),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Colors.white),
                  const SizedBox(height: 8),
                  DrawerMenuItem(
                    text: 'Notifications',
                    icon: Icons.notifications_outlined,
                    onClicked: () => _navigateToPage(context, 5),
                  ),
                  DrawerMenuItem(
                    text: 'Settings',
                    icon: Icons.settings,
                    onClicked: () => _navigateToPage(context, 6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles navigation when a drawer menu item is selected.
  ///
  /// Closes the drawer and navigates to the corresponding page based on [index].
  void _navigateToPage(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Scaffold(), // Page 1
          ),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Scaffold(), // Page 2
          ),
        );
        break;
    }
  }
}

/// A search field widget specifically designed for the drawer.
class DrawerSearchField extends StatelessWidget {
  const DrawerSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;

    return TextField(
      style: const TextStyle(color: color, fontSize: 14),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        hintText: 'Search',
        hintStyle: const TextStyle(color: color),
        prefixIcon: const Icon(Icons.search, color: color, size: 20),
        filled: true,
        fillColor: Colors.grey,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}

/// A menu item widget for the drawer.
///
/// Displays an icon and text with customized styling.
class DrawerMenuItem extends StatelessWidget {
  /// The text to display for this menu item.
  final String text;

  /// The icon to display next to the text.
  final IconData icon;

  /// Callback function when the menu item is tapped.
  final VoidCallback? onClicked;

  const DrawerMenuItem({
    required this.text,
    required this.icon,
    this.onClicked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;
    const hoverColor = Colors.white;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }
}
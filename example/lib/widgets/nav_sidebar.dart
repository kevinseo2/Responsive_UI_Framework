import 'package:flutter/material.dart';
import 'package:responsive_ui_framework/responsive_ui_framework.dart';

class NavSidebar extends StatelessWidget {
  const NavSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.grey[900],
      child: Column(
        children: [
          const SizedBox(height: 32),
          _buildNavItem(
            context: context,
            icon: Icons.home,
            label: 'Home',
            isSelected: true,
          ),
          _buildNavItem(
            context: context,
            icon: Icons.search,
            label: 'Search',
          ),
          _buildNavItem(
            context: context,
            icon: Icons.movie,
            label: 'Movies',
          ),
          _buildNavItem(
            context: context,
            icon: Icons.tv,
            label: 'TV Shows',
          ),
          _buildNavItem(
            context: context,
            icon: Icons.settings,
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    bool isSelected = false,
  }) {
    return AccessibleFocusable(
      semanticsLabel: '$label navigation button',
      child: TouchInputHandler(
        onTap: () {
          // Handle navigation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navigate to: $label')),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? Colors.blue : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

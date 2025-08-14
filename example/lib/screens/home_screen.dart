import 'package:flutter/material.dart';
import 'package:responsive_ui_framework/responsive_ui_framework.dart';
import '../widgets/content_row.dart';
import '../widgets/focus_grid.dart';
import '../widgets/nav_sidebar.dart';
import '../models/content_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ContentItem> featuredContent = [
    ContentItem(id: '1', title: 'Featured Movie 1', type: 'movie'),
    ContentItem(id: '2', title: 'Featured Show 1', type: 'tv'),
    ContentItem(id: '3', title: 'Featured Movie 2', type: 'movie'),
  ];

  final List<ContentItem> recentContent = [
    ContentItem(id: '4', title: 'Recent Movie 1', type: 'movie'),
    ContentItem(id: '5', title: 'Recent Show 1', type: 'tv'),
    ContentItem(id: '6', title: 'Recent Movie 2', type: 'movie'),
  ];

  final List<ContentItem> recommendedContent = [
    ContentItem(id: '7', title: 'Recommended 1', type: 'movie'),
    ContentItem(id: '8', title: 'Recommended 2', type: 'tv'),
    ContentItem(id: '9', title: 'Recommended 3', type: 'movie'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NavSidebar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ContentRow(
                    title: 'Featured',
                    items: featuredContent,
                    isLarge: true,
                  ),
                ),
                SliverToBoxAdapter(
                  child: ContentRow(
                    title: 'Recent',
                    items: recentContent,
                  ),
                ),
                SliverToBoxAdapter(
                  child: ContentRow(
                    title: 'Recommended',
                    items: recommendedContent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultLayout() {
    return Scaffold(
      body: Row(
        children: [
          const NavSidebar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ContentRow(
                    title: 'Featured',
                    items: featuredContent,
                    isLarge: true,
                  ),
                ),
                SliverToBoxAdapter(
                  child: ContentRow(
                    title: 'Recent',
                    items: recentContent,
                  ),
                ),
                SliverToBoxAdapter(
                  child: ContentRow(
                    title: 'Recommended',
                    items: recommendedContent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUltraWideLayout() {
    return Scaffold(
      body: Row(
        children: [
          const NavSidebar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ContentRow(
                    title: 'Featured',
                    items: featuredContent,
                    isLarge: true,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ContentRow(
                          title: 'Recent',
                          items: recentContent,
                        ),
                      ),
                      Expanded(
                        child: ContentRow(
                          title: 'Recommended',
                          items: recommendedContent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout() {
    return Scaffold(
      body: Row(
        children: [
          const NavSidebar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ContentRow(
                    title: 'Featured',
                    items: featuredContent,
                    isLarge: true,
                  ),
                ),
                SliverToBoxAdapter(
                  child: ContentRow(
                    title: 'Recent',
                    items: recentContent,
                  ),
                ),
                SliverToBoxAdapter(
                  child: ContentRow(
                    title: 'Recommended',
                    items: recommendedContent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactLayout() {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('TV Home'),
            floating: true,
          ),
          SliverToBoxAdapter(
            child: ContentRow(
              title: 'Featured',
              items: featuredContent,
              isLarge: true,
            ),
          ),
          SliverToBoxAdapter(
            child: FocusGrid(
              key: const Key('recentRecommendedGrid'),
              title: 'Recent & Recommended',
              items: [...recentContent, ...recommendedContent],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

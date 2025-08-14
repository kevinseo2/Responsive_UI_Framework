import 'package:flutter/material.dart';
import 'package:responsive_ui_framework/responsive_ui_framework.dart';
import '../models/content_item.dart';
import 'content_card.dart';

class FocusGrid extends StatelessWidget {
  final String title;
  final List<ContentItem> items;

  const FocusGrid({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 16 / 9,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return AccessibleFocusable(
              semanticsLabel: '${items[index].title}, ${items[index].type}',
              child: TouchInputHandler(
                onTap: () {
                  // Handle item selection
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected: ${items[index].title}')),
                  );
                },
                child: ContentCard(
                  item: items[index],
                  isLarge: false,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

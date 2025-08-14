import 'package:flutter/material.dart';
import 'package:responsive_ui_framework/responsive_ui_framework.dart';
import '../models/content_item.dart';
import 'content_card.dart';

class ContentRow extends StatelessWidget {
  final String title;
  final List<ContentItem> items;
  final bool isLarge;

  const ContentRow({
    Key? key,
    required this.title,
    required this.items,
    this.isLarge = false,
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
        SizedBox(
          height: isLarge ? 400 : 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
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
                    isLarge: isLarge,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

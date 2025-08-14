import 'package:flutter/material.dart';
import '../models/content_item.dart';

class ContentCard extends StatelessWidget {
  final ContentItem item;
  final bool isLarge;

  const ContentCard({
    Key? key,
    required this.item,
    this.isLarge = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: isLarge ? 300 : 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade700,
            ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                item.type == 'movie' ? Icons.movie : Icons.tv,
                size: isLarge ? 64 : 32,
                color: Colors.white24,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isLarge ? 18 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.type.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isLarge ? 14 : 12,
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
}

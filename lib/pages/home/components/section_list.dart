import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/models/section.dart';

import 'item_tile.dart';
import 'section_header.dart';

class SectionList extends StatelessWidget {
  final Section section;

  const SectionList({Key key, this.section}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(section: section),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: section.items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (_, int index) {
                return ItemTile(item: section.items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

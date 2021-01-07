import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/managers/home_manager.dart';
import 'package:loja_virtual/shared/models/section.dart';
import 'package:provider/provider.dart';

import 'add_title_widget.dart';
import 'item_tile.dart';
import 'section_header.dart';

class SectionList extends StatelessWidget {
  final Section section;

  const SectionList({Key key, this.section}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(),
            SizedBox(
              height: 150,
              child: Consumer<Section>(
                builder: (_, section, __) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_, __) => const SizedBox(width: 4),
                    itemCount: homeManager.isEditing
                        ? section.items.length + 1
                        : section.items.length,
                    itemBuilder: (_, index) {
                      if (index < section.items.length) {
                        return ItemTile(item: section.items[index]);
                      } else {
                        return AddTileWidget();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

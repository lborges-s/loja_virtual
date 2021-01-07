import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/managers/home_manager.dart';
import 'package:loja_virtual/shared/managers/user_manager.dart';
import 'package:loja_virtual/shared/widgets/custom_drawer/custom_drawer.dart';
import 'package:provider/provider.dart';

import 'components/add_section_widget.dart';
import 'components/section_list.dart';
import 'components/section_staggered_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 211, 118, 130),
                  Color.fromARGB(255, 253, 181, 168)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          CustomScrollView(
            slivers: <Widget>[
              Consumer<UserManager>(
                builder: (_, userManager, __) {
                  return SliverAppBar(
                    backgroundColor: Colors.transparent,
                    snap: true,
                    floating: true,
                    elevation: 0,
                    flexibleSpace: const FlexibleSpaceBar(
                      title: Text('Loja do Lucas'),
                      centerTitle: true,
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/cart'),
                      ),
                      Consumer2<UserManager, HomeManager>(
                        builder: (_, userManager, homeManager, __) {
                          if (userManager.adminEnabled &&
                              !homeManager.isLoading) {
                            if (homeManager.isEditing) {
                              return PopupMenuButton(
                                onSelected: (e) {
                                  if (e == 'Salvar') {
                                    homeManager.saveEditing();
                                  } else {
                                    homeManager.discardEditing();
                                  }
                                },
                                itemBuilder: (_) {
                                  return ['Salvar', 'Descartar'].map((e) {
                                    return PopupMenuItem(
                                      value: e,
                                      child: Text(e),
                                    );
                                  }).toList();
                                },
                              );
                            } else {
                              return IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: homeManager.enterEditing,
                              );
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
              Consumer<HomeManager>(
                builder: (_, homeManager, __) {
                  if (homeManager.isLoading) {
                    return const SliverToBoxAdapter(
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        backgroundColor: Colors.transparent,
                      ),
                    );
                  }
                  final children = homeManager.sections.map<Widget>(
                    (section) {
                      switch (section.type) {
                        case 'List':
                          return SectionList(section: section);

                        case 'Staggered':
                          return SectionStaggered(section);

                        default:
                          return Container();
                      }
                    },
                  ).toList();
                  if (homeManager.isEditing) {
                    children.add(AddSectionWidget(homeManager));
                  }
                  return SliverList(
                    delegate: SliverChildListDelegate(children),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

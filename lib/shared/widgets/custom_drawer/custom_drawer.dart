import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/managers/user_manager.dart';
import 'package:loja_virtual/shared/widgets/custom_drawer/drawer_tile.dart';
import 'package:provider/provider.dart';

import 'custom_drawer_header.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 203, 236, 241),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          ListView(
            children: <Widget>[
              CustomDrawerHeader(),
              const Divider(),
              const DrawerTile(
                iconData: Icons.home,
                title: 'Início',
                page: 0,
              ),
              const DrawerTile(
                iconData: Icons.list,
                title: 'Produtos',
                page: 1,
              ),
              const DrawerTile(
                iconData: Icons.playlist_add_check,
                title: 'Meus Pedidos',
                page: 2,
              ),
              const DrawerTile(
                iconData: Icons.location_on,
                title: 'Lojas',
                page: 3,
              ),
              const Divider(),
              Consumer<UserManager>(
                builder: (_, userManager, __) {
                  if (userManager.adminEnabled) {
                    return Column(
                      children: [
                        const DrawerTile(
                          iconData: Icons.settings,
                          title: 'Usuários',
                          page: 4,
                        ),
                        const DrawerTile(
                          iconData: Icons.settings,
                          title: 'Pedidos',
                          page: 5,
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/managers/admin_users_manager.dart';
import 'package:loja_virtual/shared/widgets/custom_drawer/custom_drawer.dart';
import 'package:provider/provider.dart';

class AdminUsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: Consumer<AdminUsersManager>(
        builder: (_, adminUsersManager, __) {
          return AlphabetListScrollView(
            itemBuilder: (_, index) {
              final user = adminUsersManager.users[index];
              return ListTile(
                title: Text(
                  user.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, color: Colors.white),
                ),
                subtitle: Text(
                  user.email,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
            highlightTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            indexedHeight: (index) => 80,
            strList: adminUsersManager.names,
            showPreview: true,
          );
        },
      ),
    );
  }
}

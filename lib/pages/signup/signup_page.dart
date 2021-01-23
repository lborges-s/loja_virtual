import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/helpers/validators.dart';
import 'package:loja_virtual/shared/models/user.dart';
import 'package:loja_virtual/shared/managers/user_manager.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final user = UserModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Consumer<UserManager>(builder: (_, userManager, __) {
              return ListView(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                children: <Widget>[
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: 'Nome Completo'),
                    enabled: !userManager.isLoading,
                    validator: (name) {
                      if (name.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (name.trim().split(' ').length <= 1) {
                        return 'Preencha seu nome completo';
                      }
                      return null;
                    },
                    onSaved: (name) => user.name = name,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'E-mail'),
                    enabled: !userManager.isLoading,
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) {
                      if (email.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (!emailValid(email)) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                    onSaved: (email) => user.email = email,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'Senha'),
                    enabled: !userManager.isLoading,
                    obscureText: true,
                    validator: (pass) {
                      if (pass.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (pass.length < 6) {
                        return 'Senha muito curta';
                      }
                      return null;
                    },
                    onSaved: (pass) => user.password = pass,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: 'Repita a Senha'),
                    enabled: !userManager.isLoading,
                    obscureText: true,
                    validator: (pass) {
                      if (pass.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (pass.length < 6) {
                        return 'Senha muito curta';
                      }
                      return null;
                    },
                    onSaved: (pass) => user.confirmPassword = pass,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RaisedButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: Theme.of(context).primaryColor,
                    disabledColor:
                        Theme.of(context).primaryColor.withAlpha(100),
                    textColor: Colors.white,
                    onPressed: userManager.isLoading
                        ? null
                        : () {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();

                              if (user.password != user.confirmPassword) {
                                scaffoldKey.currentState.showSnackBar(
                                  const SnackBar(
                                    content: Text('Senhas não coincidem!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              userManager.signUp(
                                user: user,
                                onSuccess: () => Navigator.of(context).pop(),
                                onFail: (error) {
                                  scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text('Falha ao cadastrar: $error'),
                                    backgroundColor: Colors.red,
                                  ));
                                },
                              );
                              // usermanager
                            }
                          },
                    child: userManager.isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : const Text(
                            'Criar Conta',
                            style: TextStyle(fontSize: 15),
                          ),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_appl/cubits/auth/cubit/auth_cubit.dart';

import '../models/user.dart';
import '../theme.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      drawer: _drawer(context),
      body: Container(
        padding: const EdgeInsets.all(64),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              CustomTheme.gradientStart,
              CustomTheme.gradientEnd,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 1.0),
          ),
        ),
        child: _welcomeWidget(),
      ),
    );
  }

  Widget _drawer(BuildContext context) => Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(children: [
                _accountHeader(),
              ]),
            ),
            Divider(height: 0),
            SafeArea(child: _logoutButton(context)),
          ],
        ),
      );

  Widget _accountHeader() => UserAccountsDrawerHeader(
        accountName: Text(user.name),
        accountEmail: Text(user.email),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(user.initials),
        ),
      );

  Widget _logoutButton(BuildContext context) => ListTile(
        leading: Icon(Icons.logout),
        title: const Text("Esci"),
        onTap: () => context.read<AuthCubit>().logOut(),
      );

  Widget _welcomeWidget() => Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/login_logo.png'),
              fit: BoxFit.fitWidth,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: RichText(
                text: TextSpan(
                  text: "Benvenuto, ",
                  style: TextStyle(fontSize: 36.0),
                  children: [
                    TextSpan(
                        text: user.name, style: TextStyle(color: Colors.black))
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

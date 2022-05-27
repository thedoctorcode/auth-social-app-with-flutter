import 'package:flutter/material.dart';
import 'package:social_appl/pages/login_page.dart';

import '../theme.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          children: [
            _welcomeWidget(),
            _signInButton(context),
          ],
        ),
      ),
    );
  }

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
              child: Text(
                "Social App",
                style: TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _signInButton(BuildContext context) => ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 48),
          child: Text(
            "INIZIA",
            style: TextStyle(fontSize: 25),
          ),
        ),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginPage()),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:social_appl/misc/bubble_indicator_painter.dart';
import 'package:social_appl/pages/widgets/sign_in.dart';
import 'package:social_appl/pages/widgets/sign_up.dart';

import '../theme.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late PageController _pageController;

  Color signInColor = Colors.black;
  Color signUpColor = Colors.white;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
              _logoWidget(),
              _selectorWidget(),
              _pageViewWidget(),
            ],
          ),
        ),
      ),
    );
  }

  _logoWidget() => Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Image(
          image: AssetImage('assets/images/login_logo.png'),
          height: 100,
        ),
      );

  _selectorWidget() => Container(
        margin: EdgeInsets.only(top: 32.0),
        width: 300.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Color(0x552b2b2b),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: CustomPaint(
          painter: BubbleIndicatorPainter(pageController: _pageController),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () => _pageController.animateToPage(
                    0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.decelerate,
                  ),
                  child: Text(
                    "Accedi",
                    style: TextStyle(
                      color: signInColor,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () => _pageController.animateToPage(
                    1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.decelerate,
                  ),
                  child: Text(
                    "Registrati",
                    style: TextStyle(
                      color: signUpColor,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  _pageViewWidget() => Expanded(
        child: PageView(
            onPageChanged: (index) {
              setState(() {
                signInColor = index == 0 ? Colors.black : Colors.white;
                signUpColor = index == 1 ? Colors.black : Colors.white;
              });
            },
            controller: _pageController,
            children: [
              SignIn(),
              SignUp(),
            ]),
      );
}

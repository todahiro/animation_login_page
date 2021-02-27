import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimationLoginPage(),
    );
  }
}

class AnimationLoginPage extends StatefulWidget {
  @override
  _AnimationLoginPageState createState() => _AnimationLoginPageState();
}

class _AnimationLoginPageState extends State<AnimationLoginPage>
    with TickerProviderStateMixin {
  AnimationController _loginIdAnimationController;
  AnimationController _passwordAnimationController;
  AnimationController _buttonAnimationController;

  Animation<Offset> _loginIdAnimation;
  Animation<Offset> _passwordAnimation;
  Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();

    _loginIdAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _passwordAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _buttonAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    Animatable _animatable = Tween<Offset>(
      begin: Offset(-1.1, 0.0),
      end: Offset(0.0, 0.0),
    ).chain(
      CurveTween(
        curve: Curves.bounceOut,
      ),
    );

    _loginIdAnimation = _animatable.animate(_loginIdAnimationController);
    _passwordAnimation = _animatable.animate(_passwordAnimationController);
    _buttonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    )
        .chain(
          CurveTween(
            curve: Curves.bounceOut,
          ),
        )
        .animate(_buttonAnimationController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loginIdAnimationController.forward();
      Future.delayed(Duration(milliseconds: 200)).then(
            (_) => _passwordAnimationController.forward(),
      );
      Future.delayed(Duration(milliseconds: 700)).then(
            (_) => _buttonAnimationController.forward(),
      );
    });
  }

  @override
  void dispose() {
    _loginIdAnimationController.dispose();
    _passwordAnimationController.dispose();
    _buttonAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Animation Login Page',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              'Login',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  AnimatedBuilder(
                    animation: _loginIdAnimation,
                    builder: (BuildContext context, _) {
                      return FractionalTranslation(
                        translation: _loginIdAnimation.value,
                        child: CupertinoTextField(
                          placeholder: 'id',
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AnimatedBuilder(
                    animation: _passwordAnimation,
                    builder: (BuildContext context, _) {
                      return FractionalTranslation(
                        translation: _passwordAnimation.value,
                        child: CupertinoTextField(
                          placeholder: 'password',
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  AnimatedBuilder(
                    animation: _buttonAnimation,
                    builder: (BuildContext context, _) {
                      return FadeTransition(
                        opacity: _buttonAnimation,
                        child: Transform(
                          transform: _generateMatrix(_buttonAnimation),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text(
                                'ログイン',
                              ),
                              onPressed: () => null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Matrix4 _generateMatrix(Animation animation) {
    final value = lerpDouble(30.0, 0, animation.value);
    return Matrix4.translationValues(0.0, value, 0.0);
  }
}

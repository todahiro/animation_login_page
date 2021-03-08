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
  AnimationController? _loginIdAnimationController;
  AnimationController? _passwordAnimationController;
  AnimationController? _buttonAnimationController;

  Animation<double>? _loginIdAnimation;
  Animation<double>? _passwordAnimation;
  Animation<double>? _buttonAnimation;

  final globalKey = GlobalKey();
  double formWidth = 0;

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

    final Animatable<double> _animatable = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).chain(
      CurveTween(
        curve: Curves.bounceOut,
      ),
    );

    _loginIdAnimation = _animatable.animate(_loginIdAnimationController!);
    _passwordAnimation = _animatable.animate(_passwordAnimationController!);
    _buttonAnimation = _animatable.animate(_buttonAnimationController!);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      RenderBox? box = globalKey.currentContext!.findRenderObject() as RenderBox;
      formWidth = box.size.width;
      _loginIdAnimationController!.forward();
      Future.delayed(Duration(milliseconds: 200)).then(
            (_) => _passwordAnimationController!.forward(),
      );
      Future.delayed(Duration(milliseconds: 700)).then(
            (_) => _buttonAnimationController!.forward(),
      );
    });
  }

  @override
  void dispose() {
    _loginIdAnimationController!.dispose();
    _passwordAnimationController!.dispose();
    _buttonAnimationController!.dispose();

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
                    animation: _loginIdAnimation!,
                    builder: (BuildContext context, _) {
                      return Transform(
                        transform: _generateFormMatrix(_loginIdAnimation!),
                        child: CupertinoTextField(
                          key: globalKey,
                          placeholder: 'id',
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AnimatedBuilder(
                    animation: _passwordAnimation!,
                    builder: (BuildContext context, _) {
                      return Transform(
                        transform: _generateFormMatrix(_passwordAnimation!),
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
                    animation: _buttonAnimation!,
                    builder: (BuildContext context, _) {
                      return FadeTransition(
                        opacity: _buttonAnimation!,
                        child: Transform(
                          transform: _generateButtonMatrix(_buttonAnimation!),
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

  Matrix4 _generateFormMatrix(Animation animation) {
    final value = lerpDouble(formWidth + 35.0, 0, animation.value);
    return Matrix4.translationValues(-value!, 0.0, 0.0);
  }

  Matrix4 _generateButtonMatrix(Animation animation) {
    final value = lerpDouble(30.0, 0, animation.value);
    return Matrix4.translationValues(0.0, value!, 0.0);
  }
}

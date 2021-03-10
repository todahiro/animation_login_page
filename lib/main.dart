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
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _passwordAnimationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _buttonAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    // ログインIDフォームとログインボタンのアニメーション定義
    Animatable<double> _animatable = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).chain(
      CurveTween(
        curve: Curves.bounceOut,
      ),
    );

    // パスワードフォームのアニメーション定義
    Animatable<double> _passwordAnimatable = TweenSequence([
      // アニメーションが1.2秒で、最初の0.4秒は待機
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 0.0,
        ),
        weight: 400 / 1200, // 1.2秒のアニメーションのうちの0.4秒
      ),
      // アニメーションが1.2秒で、0.8秒かけてアニメーション
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(
          CurveTween(
            curve: Curves.bounceOut,
          ),
        ),
        weight: 800 / 1200, // 1.2秒のアニメーションのうちの0.8秒
      ),
    ]);

    _loginIdAnimation = _animatable.animate(_loginIdAnimationController!);
    _passwordAnimation = _passwordAnimatable.animate(_passwordAnimationController!);
    _buttonAnimation = _animatable.animate(_buttonAnimationController!);

    // Widgetが描画されてから、フォームの長さを取得して、アニメーションを発火させる
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      RenderBox? box = globalKey.currentContext!.findRenderObject() as RenderBox;
      formWidth = box.size.width;
      // アニメーションの開始
      _loginIdAnimationController!.forward();
      _passwordAnimationController!.forward();
      // 1秒後にアニメーション開始
      Future.delayed(Duration(milliseconds: 1000)).then(
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

  /// フォームがスライドするアニメーションの移動量(画面左のPadding(35px) + フォームの長さ)
  Matrix4 _generateFormMatrix(Animation animation) {
    final value = lerpDouble(35.0 + formWidth, 0, animation.value);
    return Matrix4.translationValues(-value!, 0.0, 0.0);
  }

  /// ボタンが上にスライドするアニメーションの移動量(30px)
  Matrix4 _generateButtonMatrix(Animation animation) {
    final value = lerpDouble(30.0, 0, animation.value);
    return Matrix4.translationValues(0.0, value!, 0.0);
  }
}

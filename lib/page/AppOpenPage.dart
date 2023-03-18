import 'dart:async';
import 'package:aichat/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:aichat/page/HomePage.dart';
import '../utils/Config.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late LottieBuilder _splashLottie;
  late AnimationController _lottieController;

  bool _showAppOpenAnimate = true;
  bool _isAnimateFileLoaded = false; // lottie json loaded state

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _lottieInit();
  }

  void _lottieInit() {
    _lottieController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _lottieController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        _lottieController.stop();
        _showAppOpenAnimate = false;
        Utils.pushReplacement(context, const HomePage());
      }
    });
    _splashLottie = Lottie.asset(
      'images/splash.json',
      repeat: false,
      animate: false,
      width: double.infinity,
      height: double.infinity,
      controller: _lottieController,
      onLoaded: (composition) {
        _isAnimateFileLoaded = true;
        _lottieController.forward(from: 0);
        _lottieController.duration = composition.duration;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: renderContent());
  }

  Widget renderContent() {
    if (!_showAppOpenAnimate) {
      return Container();
    }
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                child: _splashLottie,
              ),
              if (_isAnimateFileLoaded)
                Text(
                  Config.appName,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    height: 28 / 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (!_isAnimateFileLoaded) const SizedBox(height: 28),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _lottieController.dispose();

    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }

    super.dispose();
  }
}

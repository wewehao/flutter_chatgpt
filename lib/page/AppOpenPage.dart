import 'dart:async';
import 'package:aichat/stores/AIChatStore.dart';
import 'package:aichat/utils/AdCommon.dart';
import 'package:aichat/utils/Utils.dart';
import 'package:aichat/utils/OpenAppAd.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:aichat/page/HomePage.dart';
import 'package:provider/provider.dart';
import '../utils/Config.dart';

const int maxCheckTime = 8; // Maximum detection time
int startCheckTime = 0;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late LottieBuilder _splashLottie;
  late AnimationController _lottieController;
  int currentTimeMillis = -1;

  bool _showAppOpenAnimate = true;
  bool _isAnimateFileLoaded = false; // lottie json loaded state
  late OpenAppAd _openAppAd;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    startCheckTime = DateTime.now().millisecondsSinceEpoch;
    _checkFirstInstall();

    /// Initialize the open screen AD
    print('---openAppAdId---$openAppAdId');
    _openAppAd = getOpenAppAdInstance(openAppAdId);
    _lottieInit();
  }

  Future _checkFirstInstall() async {
    final store = Provider.of<AIChatStore>(context, listen: false);
    bool isInstall = await Utils.getInstall();
    Utils.saveInstall();
    if (!isInstall) {
      store.addApiCount(Config.watchAdApiCount);
    }
  }

  void _lottieInit() {
    _lottieController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _lottieController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        _lottieController.forward(from: 0);
        _checkOpenAdLoadStatus(() {
          _lottieController.stop();
          _showAppOpenAnimate = false;
          _openAppAd.showOpenAppAd(() {
            print('---AppOpenAd show success---');
            Utils.pushReplacement(context, const HomePage());
          });
        });
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

  void _checkOpenAdLoadStatus(Function callback) async {
    if (!Config.isAdShow()) {
      callback();
      return;
    }
    if (_openAppAd.isLoadFail) {
      print('---AppOpenAd -_checkOpenAdLoadStatus isLoadFail--');
      callback();
      return;
    }
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;
      if (now - startCheckTime > maxCheckTime * 1000 || _openAppAd.isLoadFail) {
        _lottieController.stop();
        _lottieController.value = 1;
        setState(() {});
        _timer?.cancel();
        _timer = null;
        timer.cancel();
        print('---AppOpenAd -_checkOpenAdLoadStatus delayed callback--');
        callback();
        return;
      }
      if (_openAppAd.isAdAvailable) {
        _lottieController.stop();
        _lottieController.value = 1;
        setState(() {});
        _timer?.cancel();
        _timer = null;
        timer.cancel();
        print('---AppOpenAd -_checkOpenAdLoadStatus isAdAvailable delayed callback--');
        callback();
      }
    });
  }
}

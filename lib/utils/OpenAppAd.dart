import 'package:aichat/utils/Utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'Config.dart';

class OpenAppAd {
  AppOpenAd? _appOpenAd;
  String adUnitId = '';
  bool _isLoadFail = false;

  OpenAppAd(this.adUnitId) {}

  /// Whether to display ads
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  /// Whether the sdk failed to load
  bool get isLoadFail {
    return _isLoadFail;
  }

  void loadAd() async {
    if (!Config.isAdShow()) {
      return;
    }
    AppOpenAd.load(
      adUnitId: adUnitId,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print('AppOpenAd loaded $adUnitId');
          _appOpenAd = ad;
          _isLoadFail = false;
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load $adUnitId $error');
          _isLoadFail = true;
        },
      ),
    );
  }

  void showOpenAppAd(Function callback) async {
    if (!Config.isAdShow()) {
      callback();
      return;
    }

    if (_isLoadFail) {
      print('---AppOpenAd _isLoadFail---');
      callback();
      return;
    }

    if (_appOpenAd == null) {
      print('---AppOpenAd _appOpenAd is null---');
      callback();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        print('AppOpenAd onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        callback();
        print('AppOpenAd onAdFailedToShowFullScreenContent $error');
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        callback();
        print('AppOpenAd onAdDismissedFullScreenContent');
        ad.dispose();
        _appOpenAd = null;
      },
    );

    _appOpenAd!.show();
  }
}

getOpenAppAdInstance(adUnitId) {
  OpenAppAd _instance = OpenAppAd(adUnitId);
  print("OpenAppAd Instance $adUnitId create");
  _instance.loadAd();
  return _instance;
}

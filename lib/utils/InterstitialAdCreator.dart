import 'package:aichat/utils/Utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'Config.dart';

class InterstitialAdCreator {
  InterstitialAd? _interstitialAd;
  String adUnitId = '';
  bool isLoaded = false;

  InterstitialAdCreator(this.adUnitId) {}

  createShowInterstitialAd({
    Function? loadedCallback,
    Function? loadFailCallback,
  }) async {
    if (!Config.isAdShow()) {
      return;
    }
    if (isLoaded) {
      return;
    }
    isLoaded = true;

    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          isLoaded = false;
          print('InterstitialAd loaded $adUnitId');
          _interstitialAd = ad;
          _interstitialAd!.setImmersiveMode(true);
          if (loadedCallback != null) {
            loadedCallback();
          }
        },
        onAdFailedToLoad: (LoadAdError error) {
          isLoaded = false;
          print('InterstitialAd load fail $adUnitId $error');
          _interstitialAd = null;
          if (loadFailCallback != null) {
            loadFailCallback();
          }
        },
      ),
    );
  }

  void showInterstitialAd({
    Function? successCallback,
    Function? failCallback,
    Function? openCallback,
  }) async {
    if (!Config.isAdShow()) {
      return;
    }
    if (_interstitialAd == null) {
      print('InterstitialAd  Warning: attempt to show interstitial before loaded.');
      if (failCallback != null) {
        failCallback();
      }
      createShowInterstitialAd();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        print('InterstitialAd onAdShowedFullScreenContent');
        if (openCallback != null) {
          openCallback();
        }
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('InterstitialAd onAdDismissedFullScreenContent');
        if (successCallback != null) {
          successCallback();
        }
        ad.dispose();
        dispose();
        createShowInterstitialAd();
      },
      onAdClicked: (InterstitialAd ad) {},
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        if (failCallback != null) {
          failCallback();
        }
        print('InterstitialAd onAdFailedToShowFullScreenContent $error');
        ad.dispose();
        dispose();
        createShowInterstitialAd();
      },
    );

    _interstitialAd!.show();
  }

  void dispose() async {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}

getInterstitialAdInstance(
  adUnitId, {
  Function? loadedCallback,
  Function? loadFailCallback,
}) {
  InterstitialAdCreator _instance = InterstitialAdCreator(adUnitId);
  print("InterstitialAd Instance $adUnitId create");
  _instance.createShowInterstitialAd(loadedCallback: loadedCallback, loadFailCallback: loadFailCallback);
  return _instance;
}

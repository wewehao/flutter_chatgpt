import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import './Utils.dart';
import 'Config.dart';

class RewardedInterstitialAdCreator {
  RewardedInterstitialAd? rewardedInterstitialAd;
  String adUnitId = '';
  bool isLoading = false;
  Timer? _timer;

  RewardedInterstitialAdCreator(this.adUnitId) {}

  createShowRewardedInterstitialAd({
    Function? loadedCallback,
    Function? loadFailCallback,
  }) async {
    if (!Config.isAdShow()) {
      return;
    }
    if (isLoading) {
      return;
    }
    isLoading = true;

    await RewardedInterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {
          isLoading = false;
          print('RewardedInterstitialAd loaded $adUnitId');
          rewardedInterstitialAd = ad;
          rewardedInterstitialAd!.setImmersiveMode(true);
          if (loadedCallback != null) {
            loadedCallback();
          }
        },
        onAdFailedToLoad: (LoadAdError error) {
          isLoading = false;
          print('RewardedInterstitialAd load fail $adUnitId $error');
          rewardedInterstitialAd = null;
          if (loadFailCallback != null) {
            loadFailCallback();
          }
        },
      ),
    );
  }

  void showRewardedInterstitialAd({
    Function? successCallback,
    Function? failCallback,
    Function? openCallback,
  }) async {
    if (!Config.isAdShow()) {
      return;
    }
    if (isLoading) {
      print('RewardedInterstitialAd is loading');
      _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
        if (isLoading) {
          print('RewardedInterstitialAd periodic: ad is loading');
          return;
        }
        if (rewardedInterstitialAd == null) {
          timer.cancel();
          print('RewardedInterstitialAd periodic: ad is null');
          if (failCallback != null) {
            failCallback();
          }
          return;
        }
        timer.cancel();
        showRewardedInterstitialAd(
          successCallback: successCallback,
          failCallback: failCallback,
          openCallback: openCallback,
        );
      });
      return;
    }
    if (rewardedInterstitialAd == null) {
      print('RewardedInterstitialAd is null');
      if (failCallback != null) {
        failCallback();
      }
      createShowRewardedInterstitialAd();
      return;
    }

    rewardedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) {
        print('RewardedInterstitialAd ad onAdShowedFullScreenContent');
        if (openCallback != null) {
          openCallback();
        }
      },
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        print('RewardedInterstitialAd onAdDismissedFullScreenContent');
        if (successCallback != null) {
          successCallback();
        }
        ad.dispose();
        dispose();
        createShowRewardedInterstitialAd();
      },
      onAdClicked: (RewardedInterstitialAd ad) {},
      onAdFailedToShowFullScreenContent: (RewardedInterstitialAd ad, AdError error) {
        if (failCallback != null) {
          failCallback();
        }
        print('RewardedInterstitialAd onAdFailedToShowFullScreenContent $error');
        ad.dispose();
        dispose();
        createShowRewardedInterstitialAd();
      },
    );

    rewardedInterstitialAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('RewardedInterstitialAd onUserEarnedReward ${reward.amount}  ${reward.type}');
      },
    );
  }

  void dispose() async {
    // rewardedInterstitialAd?.dispose();
    // rewardedInterstitialAd = null;
    _timer?.cancel();
  }
}

getRewardedInterstitialAdInstance(
  adUnitId, {
  Function? loadedCallback,
  Function? loadFailCallback,
}) {
  RewardedInterstitialAdCreator _instance = RewardedInterstitialAdCreator(adUnitId);
  print("RewardedInterstitialAd Instance $adUnitId create");
  _instance.createShowRewardedInterstitialAd(loadedCallback: loadedCallback, loadFailCallback: loadFailCallback);
  return _instance;
}

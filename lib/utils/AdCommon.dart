import 'dart:io';
import 'Config.dart';

/// Open screen ad id
String openAppAdId = Platform.isAndroid
    ? Config.isDebug
        ? 'ca-app-pub-3940256099942544/3419835294'
        : 'ca-app-pub-3940256099942544/3419835294'
    : Config.isDebug
        ? 'ca-app-pub-3940256099942544/3419835294'
        : 'ca-app-pub-3940256099942544/3419835294';

/// task interstitial
String taskAdId = Platform.isAndroid
    ? Config.isDebug
        ? 'ca-app-pub-3940256099942544/1033173712'
        : 'ca-app-pub-3940256099942544/1033173712'
    : Config.isDebug
        ? 'ca-app-pub-3940256099942544/1033173712'
        : 'ca-app-pub-3940256099942544/1033173712';

/// Task Interstitial Rewarded Ads
String taskRewardAdId = Platform.isAndroid
    ? Config.isDebug
        ? 'ca-app-pub-3940256099942544/5354046379'
        : 'ca-app-pub-3940256099942544/5354046379'
    : Config.isDebug
        ? 'ca-app-pub-3940256099942544/5354046379'
        : 'ca-app-pub-3940256099942544/5354046379';

/// Home Banner
String homeBannerAd = Platform.isAndroid
    ? Config.isDebug
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/6300978111'
    : Config.isDebug
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/6300978111';

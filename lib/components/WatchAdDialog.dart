import 'package:aichat/utils/Config.dart';
import 'package:flutter/material.dart';
import 'package:aichat/stores/AIChatStore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:aichat/utils/RewardedInterstitialAdCreator.dart';
import 'package:aichat/utils/AdCommon.dart';

class WatchAdDialog extends StatefulWidget {
  final VoidCallback onClose;

  const WatchAdDialog({Key? key, required this.onClose}) : super(key: key);

  @override
  _WatchAdDialog createState() => _WatchAdDialog();
}

class _WatchAdDialog extends State<WatchAdDialog> with TickerProviderStateMixin {
  final LottieBuilder _splashLottie = Lottie.asset("images/splash.json");
  late RewardedInterstitialAdCreator _rewardedInterstitialAdCreator;

  @override
  void initState() {
    super.initState();

    _rewardedInterstitialAdCreator = getRewardedInterstitialAdInstance(taskRewardAdId);
  }

  @override
  void dispose() {
    _rewardedInterstitialAdCreator.dispose();
    EasyLoading.dismiss();
    super.dispose();
  }

  void _showAd() {
    final store = Provider.of<AIChatStore>(context, listen: false);
    EasyLoading.show(status: 'loading...');

    _rewardedInterstitialAdCreator.showRewardedInterstitialAd(
      successCallback: () {
        store.addApiCount(Config.watchAdApiCount);
        EasyLoading.showToast(
          'Get rewards ${Config.watchAdApiCount} times!',
          dismissOnTap: true,
        );
      },
      failCallback: () {
        EasyLoading.dismiss();
        EasyLoading.showToast(
          'Advertisement loading failure',
          dismissOnTap: true,
        );
      },
      openCallback: () {
        EasyLoading.dismiss();
        widget.onClose();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      iconPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      buttonPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onClose();
                  },
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Image(
                      width: 32,
                      height: 32,
                      image: AssetImage('images/close_icon.png'),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: _splashLottie,
                ),
              ],
            ),
            const Text(
              'Get messages',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                height: 24 / 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Text(
                'Go watch a video and get rewarded with ${Config.watchAdApiCount} messages',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  height: 20 / 14,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      actions: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          child: Ink(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(87, 87, 227, 1.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: const Color.fromRGBO(55, 55, 201, 1.0),
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                _showAd();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: const Text(
                  'Watch Ads',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

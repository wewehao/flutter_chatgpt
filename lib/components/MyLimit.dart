import 'package:aichat/components/WatchAdDialog.dart';
import 'package:aichat/utils/Config.dart';
import 'package:flutter/material.dart';
import 'package:aichat/stores/AIChatStore.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class MyLimit extends StatefulWidget {
  const MyLimit({Key? key}) : super(key: key);

  @override
  _MyLimitState createState() => _MyLimitState();
}

class _MyLimitState extends State<MyLimit> with TickerProviderStateMixin {
  final LottieBuilder _giftIcon = Lottie.asset("images/gift.json");

  @override
  void initState() {
    super.initState();
  }

  /// Display AD change times popover
  void showAdDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WatchAdDialog(
          onClose: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Config.isAdShow()) {
      return Container();
    }

    final store = Provider.of<AIChatStore>(context, listen: true);
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            showAdDialog();
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 3),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1,
                color: const Color.fromRGBO(96, 138, 32, 1.0),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  transform: Matrix4.translationValues(0, -0.8, 0.0),
                  width: 22,
                  child: _giftIcon,
                ),
                const SizedBox(width: 1),
                Text(
                  '${store.apiCount} more times',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color.fromRGBO(63, 140, 58, 1.0),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:aichat/utils/Chatgpt.dart';
import 'package:aichat/utils/Config.dart';
import 'package:aichat/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:sp_util/sp_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:aichat/stores/AIChatStore.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with WidgetsBindingObserver {
  bool isCopying = false;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // TODO: Switch from background to foreground, the interface is visible.
        break;
      case AppLifecycleState.paused:

        /// TODO: Switch from foreground to background, the interface is not visible.
        break;
      case AppLifecycleState.inactive:

        /// TODO: Handle this case.
        break;
      case AppLifecycleState.detached:

        /// TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.white,
              highlightColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
              child: SizedBox(
                height: 60,
                child: Row(
                  children: const [
                    SizedBox(width: 24),
                    Image(
                      width: 18,
                      image: AssetImage('images/back_icon.png'),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Setting",
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 18,
                        height: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Container(
        color: const Color(0xffffffff),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  renderItemWidget(
                    'images/privacy_policy_icon.png',
                    Colors.red,
                    32,
                    'Privacy Policy',
                    () {
                      final Uri url = Uri.parse('https://wewehao.github.io/Privacy/privacy.html');
                      Utils.launchURL(url);
                    },
                  ),
                  // renderItemWidget('images/share_icon.png', Colors.green, 26, 'Share App', () {
                  //   Share.share(
                  //     Platform.isAndroid
                  //         ? 'https://play.google.com/store/apps/details?id=com.wewehao.aichat'
                  //         : "https://apps.apple.com/app/id***",
                  //   );
                  // },),
                  renderItemWidget(
                    'images/star_icon.png',
                    Colors.amber,
                    26,
                    'Rating App',
                    () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => RatingDialog(
                          initialRating: 5.0,
                          title: const Text(
                            'Did you like the app?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          message: const Text(
                            'Tap a star to set your rating. Add more description here if you want.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                            ),
                          ),
                          image: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            clipBehavior: Clip.antiAlias,
                            child: const Image(
                              width: 52,
                              height: 52,
                              image: AssetImage('images/logo.png'),
                            ),
                          ),
                          submitButtonText: 'Submit',
                          commentHint: 'Set your custom comment hint',
                          onCancelled: () => print('cancelled'),
                          onSubmitted: (response) {
                            print('rating: ${response.rating}, comment: ${response.comment}');
                          },
                        ),
                      );
                    },
                  ),
                  renderItemWidget(
                    'images/email_icon.png',
                    Colors.purpleAccent,
                    26,
                    'Feedback',
                    () {
                      String recipientEmail = Config.contactEmail;
                      String subject = "${Config.appName} - feedback";
                      const String body = '';
                      final url = 'mailto:$recipientEmail?subject=$subject&body=$body';
                      Utils.launchURL(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                        onLaunchFail: () {
                          Clipboard.setData(ClipboardData(text: recipientEmail));
                          EasyLoading.showToast(
                            'Email address has been copied',
                            dismissOnTap: true,
                          );
                        },
                      );
                    },
                  ),
                  renderItemWidget(
                    'images/key_icon.png',
                    Colors.lightGreen,
                    26,
                    'Customize OpenAI Key',
                    () async {
                      String cacheKey = await ChatGPT.getCacheOpenAIKey();
                      _textEditingController.text = cacheKey;
                      _showCustomOpenAIKeyDialog();
                    },
                  ),

                  /// Empty storage
                  if (Config.isDebug)
                    renderItemWidget(
                      'images/debug_icon.png',
                      Colors.indigo,
                      22,
                      'Debug: Clear Storage',
                      () {
                        ChatGPT.storage.erase();
                        final store = Provider.of<AIChatStore>(context, listen: false);
                        store.syncStorage();
                        SpUtil.clear();
                        EasyLoading.showToast('Clear Storage Success!');
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget renderItemWidget(
    String iconPath,
    Color iconBgColor,
    double iconSize,
    String title,
    GestureTapCallback back, {
    String rightIconSrc = 'images/arrow_icon.png',
  }) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: back,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.white),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: iconSize,
                        height: iconSize,
                        child: Image(
                          image: AssetImage(iconPath),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                if (rightIconSrc != '')
                  Row(
                    children: [
                      Image(
                        image: AssetImage(rightIconSrc),
                        width: 18,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const Divider(
            height: 1,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showCustomOpenAIKeyDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Custom OpenAI Key'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textEditingController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Please input your key'),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  if (isCopying) {
                    return;
                  }
                  isCopying = true;
                  await Clipboard.setData(
                    const ClipboardData(
                      text: 'https://platform.openai.com/',
                    ),
                  );
                  EasyLoading.showToast(
                    'Copy successfully!',
                    dismissOnTap: true,
                  );
                  isCopying = false;
                },
                child: SingleChildScrollView(
                  child: Wrap(
                    children: const [
                      Text(
                        '* Custom key can use the APP without restrictions.',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          color: Color.fromRGBO(220, 0, 0, 1.0),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '* You will get the APP version without ads.',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          color: Color.fromRGBO(220, 0, 0, 1.0),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '* The AI Chat APP does not collect this key.',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          color: Color.fromRGBO(126, 126, 126, 1.0),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '* The Key we provide may report an error, and custom keys need to be created at https://platform.openai.com/ .',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          color: Color.fromRGBO(126, 126, 126, 1.0),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '* Click Copy URL.',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          color: Color.fromRGBO(126, 126, 126, 1.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _textEditingController.clear();
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                await ChatGPT.setOpenAIKey(_textEditingController.text);
                _textEditingController.clear();
                Navigator.of(context).pop(true);
                EasyLoading.showToast(
                  'Successful setting!',
                  dismissOnTap: true,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_util/sp_util.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static Utils get instance => _getInstance();
  static Utils? _instance;

  static Utils _getInstance() {
    if (_instance == null) {
      _instance = Utils();
    }
    return _instance!;
  }

  static jumpPage(BuildContext context, Widget widget) {
    PageRoute builder = MaterialPageRoute(builder: (context) {
      return widget;
    });

    Navigator.push(context, builder);
  }

  static pushReplacement(BuildContext context, Widget widget) {
    PageRoute builder = PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 0),
      pageBuilder: (BuildContext context, Animation<double> animation, Animation secondaryAnimation) {
        return widget;
      },
    );
    Navigator.pushReplacement(context, builder);
  }

  /// Save whether to install for the first time
  static void saveInstall() async {
    await SpUtil.getInstance();
    SpUtil.putBool("install_key", true);
  }

  /// Is it the first time to install
  static Future<bool> getInstall() async {
    await SpUtil.getInstance();
    bool? isInstall = SpUtil.getBool("install_key");
    if (isInstall == null) {
      return false;
    }
    return isInstall;
  }

  static launchURL(
    Uri url, {
    LaunchMode mode = LaunchMode.externalNonBrowserApplication,
    Function? onLaunchFail,
  }) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: mode,
      );
    } else {
      if (onLaunchFail != null) {
        onLaunchFail();
      }
      throw 'Could not launch $url';
    }
  }
}

import 'package:aichat/utils/Chatgpt.dart';

class Config {
  static late Config _instance = Config._();
  factory Config() => _getInstance();
  static Config get instance => _getInstance();
  Config._() {}

  static Config _getInstance() {
    if (_instance == null) {
      _instance = Config._();
    }
    return _instance;
  }

  static bool get isDebug => !const bool.fromEnvironment('dart.vm.product');
  // static bool get isDebug => true;

  /// TODO VIP
  static bool isAdShow() {
    if (isInfiniteNumberVersion) {
      return false;
    }
    // If a custom key is set, no ads are displayed
    if (ChatGPT.getCacheOpenAIKey() != '') {
      return false;
    }
    return true;
  }

  static bool isInfiniteNumberVersion = true; // Unlimited frequency. Development and use
  static String appName = 'AI Chat';
  static String contactEmail = '895535702@qq.com';
  static int watchAdApiCount = 3;
  static int appUserAdCount = 20; // Do not actively display advertisements if the number of times exceeds (redemption page)
}

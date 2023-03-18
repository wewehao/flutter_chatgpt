import UIKit
import Flutter
import FirebaseCore
import GoogleMobileAds

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    GADMobileAds.sharedInstance().start(completionHandler: nil)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

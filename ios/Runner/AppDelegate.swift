// ios/Runner/AppDelegate.swift
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var cardDataManager: CardDataManager?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "card_data_manager",
                                       binaryMessenger: controller.binaryMessenger)

    cardDataManager = CardDataManager()

    channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "createPoolForLoadVSD":
        self?.cardDataManager?.createPoolForLoadVSD()
        result(nil)
      case "loadVSD":
        self?.cardDataManager?.loadVSD()
        result(nil)
      case "loadNFD":
        self?.cardDataManager?.loadNFD()
        result(nil)
      case "loadDPE":
        self?.cardDataManager?.loadDPE()
        result(nil)
      case "loadAMTS":
        self?.cardDataManager?.loadAMTS()
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
import Flutter
import UIKit
import WHCCareKit_iOS

public class OrgacareReaderSdkPlugin: NSObject, FlutterPlugin {

  private static var channel: FlutterMethodChannel?

  public static func register(with registrar: FlutterPluginRegistrar) {
    channel = FlutterMethodChannel(name: "orgacare_reader_sdk", binaryMessenger: registrar.messenger())
    let instance = OrgacareReaderSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel!)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let channel = OrgacareReaderSdkPlugin.channel else {
        result(FlutterError(code: "UNAVAILABLE", message: "Method channel unavailable", details: nil))
        return
    }
    let cardDataManager = CarddataManager(channel: channel)
    switch call.method {
    case "getPlatformVersion":
        let platformVersion = "iOS " + UIDevice.current.systemVersion
        cardDataManager.sendLog("getPlatformVersion called: \(platformVersion)")
        result(platformVersion)
    case "loadVSD":
        cardDataManager.loadVSD()
        result("loadVSD called")
    case "loadNFD":
        cardDataManager.loadNFD()
        result("loadNFD called")
    case "loadDPE":
        cardDataManager.loadDPE()
        result("loadDPE called")
    case "loadAMTS":
        cardDataManager.loadAMTS()
        result("loadAMTS called")
    default:
        result(FlutterMethodNotImplemented)
    }
  }

  // Change the access level of sendLog to internal or public
 public func sendLog(_ message: String) {
    OrgacareReaderSdkPlugin.channel?.invokeMethod("log", arguments: message)
  }
}
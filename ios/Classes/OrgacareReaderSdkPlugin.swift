import Flutter
import UIKit
import WHCCareKit_iOS

import Flutter
import UIKit

public class OrgacareReaderSdkPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "orgacare_reader_sdk", binaryMessenger: registrar.messenger())
    let instance = OrgacareReaderSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
     case "getPlatformVersion":
          result("iOS " + UIDevice.current.systemVersion)
     case "loadVSD":
          print("Jetzt passiert etwas")
          let cardDataManager = CarddataManager()
          result("iOS " + UIDevice.current.systemVersion)
     //   var cardDataManager: CarddataManager
        cardDataManager?.loadVSD()
        result(nil)
      case "loadNFD":
        // self?.cardDataManager?.loadNFD()
        result(nil)
      case "loadDPE":
    //    self?.cardDataManager?.loadDPE()
        result(nil)
      case "loadAMTS":
       // self?.cardDataManager?.loadAMTS()
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}

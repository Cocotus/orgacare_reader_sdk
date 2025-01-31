import Flutter
import UIKit
import WHCCareKit_iOS

public class OrgacareReaderSdkPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "orgacare_reader_sdk", binaryMessenger: registrar.messenger())
    let instance = OrgacareReaderSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
        let platformVersion = "iOS " + UIDevice.current.systemVersion
        print(platformVersion)
        result(platformVersion)
    case "loadVSD":
        print("loadVSD called")
        let cardDataManager = CarddataManager()
        cardDataManager.loadVSD()
        let feedback = "loadVSD called successfully"
        print(feedback)
        result(feedback)
    case "loadNFD":
        print("loadNFD called")
        // self?.cardDataManager?.loadNFD()
        let feedback = "loadNFD called successfully"
        print(feedback)
        result(feedback)
    case "loadDPE":
        print("loadDPE called")
        // self?.cardDataManager?.loadDPE()
        let feedback = "loadDPE called successfully"
        print(feedback)
        result(feedback)
    case "loadAMTS":
        print("loadAMTS called")
        // self?.cardDataManager?.loadAMTS()
        let feedback = "loadAMTS called successfully"
        print(feedback)
        result(feedback)
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
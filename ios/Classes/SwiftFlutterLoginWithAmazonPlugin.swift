import Flutter
import UIKit

public class SwiftFlutterLoginWithAmazonPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_login_with_amazon", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterLoginWithAmazonPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

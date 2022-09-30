import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_login_with_amazon_method_channel.dart';

abstract class FlutterLoginWithAmazonPlatform extends PlatformInterface {
  /// Constructs a FlutterLoginWithAmazonPlatform.
  FlutterLoginWithAmazonPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLoginWithAmazonPlatform _instance = MethodChannelFlutterLoginWithAmazon();

  /// The default instance of [FlutterLoginWithAmazonPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLoginWithAmazon].
  static FlutterLoginWithAmazonPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLoginWithAmazonPlatform] when
  /// they register themselves.
  static set instance(FlutterLoginWithAmazonPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

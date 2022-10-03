import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_login_with_amazon_method_channel.dart';

abstract class FlutterLoginWithAmazonPlatform extends PlatformInterface {
  /// Constructs a FlutterLoginWithAmazonPlatform.
  FlutterLoginWithAmazonPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLoginWithAmazonPlatform _instance =
      MethodChannelFlutterLoginWithAmazon();

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
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  Future<Map?> login(Map<String, dynamic> scopes) {
    throw UnimplementedError('login() has not been implemented.');
  }

  Future<Map?> getAuthCode(String codeChallenge, String codeChallengeMethod,
      Map<String, dynamic> scopes) {
    throw UnimplementedError('getAuthCode() has not been implemented.');
  }

  Future<bool?> logout() {
    throw UnimplementedError('logout() has not been implemented.');
  }

  Future<String?> getAccessToken(Map<String, dynamic> scopes) {
    throw UnimplementedError('getAccessToken() has not been implemented.');
  }
}

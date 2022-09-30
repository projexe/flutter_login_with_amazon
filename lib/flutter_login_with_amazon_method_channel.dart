import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_login_with_amazon_platform_interface.dart';

/// An implementation of [FlutterLoginWithAmazonPlatform] that uses method channels.
class MethodChannelFlutterLoginWithAmazon extends FlutterLoginWithAmazonPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_login_with_amazon');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  /// Logs in to Amazon with the provided [scopes]
  /// {
  ///   'profile': null,
  ///   'alexa:all': {
  ///     'productID': 'SomeProductId',
  ///     'productInstanceAttributes': {
  ///       'deviceSerialNumber': 'serialNumberHere',
  ///     },
  ///   },
  /// }
  ///
  /// To ensure successful login, check that the accessToken is not null
  ///
  /// returns
  /// {
  ///     'accessToken': 'access token result',
  ///     'user': {
  ///         'userEmail': 'user email result',
  ///         'userId': 'user id result',
  ///         'userName': 'user name result',
  ///         'userPostalCode': 'user postal code result',
  ///         'user info': 'user info as a Map<String,String> result',
  ///     },
  /// }
  @override
  Future<Map?> login(Map<String, dynamic> scopes) =>
      methodChannel.invokeMethod('login', scopes);

  /// To retrieve an authcode for an amazon dash device through LWA your dash device requires
  /// code verifier generation. This code verifier should be unique to the device.
  ///
  /// [codeChallenge] should be generated on the device this is either the
  /// code verifier, or a base64url encoding of the code verifier after it is SHA256 encoded
  ///
  /// [codeChallengeMethod] must be either plain or S256
  /// depending on how you generate the code challenge on the device
  ///
  /// [scopes] should look like
  /// {
  ///   'profile': null,
  ///   'dash:replenish': {
  ///     'device_model': 'SomeDeviceModel',
  ///     'serial': 'serialNumberHere',
  ///     'is_test_device': true
  ///   },
  /// }
  ///
  /// returns
  /// {
  ///     'authorizationCode': 'authorization code to send to device result',
  ///     'clientId': 'amazon client Id for device',
  ///     'redirectUri': 'amazon redirect Uri for device'
  /// }
  ///
  /// For more information:
  /// https://developer.amazon.com/docs/dash/lwa-mobile-sdk.html#prerequisites
  Future<Map?> getAuthCode(String codeChallenge,
      String codeChallengeMethod, Map<String, dynamic> scopes) =>
      methodChannel.invokeMethod('getAuthCode', {
        'codeChallenge': codeChallenge,
        'codeChallengeMethod': codeChallengeMethod,
        'scopes': scopes,
      });

  /// Logs out of amazon
  Future<bool?> logout() => methodChannel.invokeMethod('logout');

  /// Retrieves the current access token with the provided [scopes]
  Future<String?> getAccessToken(Map<String, dynamic> scopes) =>
      methodChannel.invokeMethod('getAccessToken', scopes);

}

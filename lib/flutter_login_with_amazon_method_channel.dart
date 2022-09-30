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
}

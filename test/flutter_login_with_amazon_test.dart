import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_login_with_amazon/flutter_login_with_amazon.dart';
import 'package:flutter_login_with_amazon/flutter_login_with_amazon_platform_interface.dart';
import 'package:flutter_login_with_amazon/flutter_login_with_amazon_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterLoginWithAmazonPlatform
    with MockPlatformInterfaceMixin
    implements FlutterLoginWithAmazonPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getAccessToken(Map<String, dynamic> scopes) {
    // TODO: implement getAccessToken
    throw UnimplementedError();
  }

  @override
  Future<Map?> getAuthCode(String codeChallenge, String codeChallengeMethod, Map<String, dynamic> scopes) {
    // TODO: implement getAuthCode
    throw UnimplementedError();
  }

  @override
  Future<Map?> login(Map<String, dynamic> scopes) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<bool?> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}

void main() {
  final FlutterLoginWithAmazonPlatform initialPlatform = FlutterLoginWithAmazonPlatform.instance;

  test('$MethodChannelFlutterLoginWithAmazon is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterLoginWithAmazon>());
  });

  test('getPlatformVersion', () async {
    FlutterLoginWithAmazon flutterLoginWithAmazonPlugin = FlutterLoginWithAmazon();
    MockFlutterLoginWithAmazonPlatform fakePlatform = MockFlutterLoginWithAmazonPlatform();
    FlutterLoginWithAmazonPlatform.instance = fakePlatform;

    expect(await flutterLoginWithAmazonPlugin.getPlatformVersion(), '42');
  });
}

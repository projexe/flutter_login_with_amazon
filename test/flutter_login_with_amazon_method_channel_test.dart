import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_login_with_amazon/flutter_login_with_amazon_method_channel.dart';

void main() {
  MethodChannelFlutterLoginWithAmazon platform = MethodChannelFlutterLoginWithAmazon();
  const MethodChannel channel = MethodChannel('flutter_login_with_amazon');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}

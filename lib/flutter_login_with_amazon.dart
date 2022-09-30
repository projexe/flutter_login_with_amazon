
import 'flutter_login_with_amazon_platform_interface.dart';

class FlutterLoginWithAmazon {
  Future<String?> getPlatformVersion() {
    return FlutterLoginWithAmazonPlatform.instance.getPlatformVersion();
  }
}

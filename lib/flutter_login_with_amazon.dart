
import 'flutter_login_with_amazon_platform_interface.dart';

class FlutterLoginWithAmazon {
  Future<String?> getPlatformVersion() {
    return FlutterLoginWithAmazonPlatform.instance.getPlatformVersion();
  }
  Future<Map?> login(Map<String, dynamic> scopes) {
    return FlutterLoginWithAmazonPlatform.instance.login(scopes);
  }
  Future<Map?> getAuthCode(String codeChallenge,
      String codeChallengeMethod, Map<String, dynamic> scopes) {
   return FlutterLoginWithAmazonPlatform.instance.getAuthCode(codeChallenge, codeChallengeMethod, scopes);
  }

  Future<bool?> logout() {
    return FlutterLoginWithAmazonPlatform.instance.logout();

  }
  Future<String?> getAccessToken(Map<String, dynamic> scopes) {
   return FlutterLoginWithAmazonPlatform.instance.getAccessToken(scopes);
  }
}

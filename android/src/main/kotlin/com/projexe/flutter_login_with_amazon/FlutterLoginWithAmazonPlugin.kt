package com.projexe.flutter_login_with_amazon

import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.amazon.identity.auth.device.AuthError
import com.amazon.identity.auth.device.api.Listener
import com.amazon.identity.auth.device.api.authorization.*

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

/**
 * all responses must be on the main thread because of dart
 * due to the amazon implementation using listeners its possible they come back on a different thread
 * https://flutter.dev/docs/development/platform-integration/platform-channels#jumping-to-the-ui-thread-in-android
 * **/
private fun resultError(result: Result, authError: AuthError? = null){
  Handler(Looper.getMainLooper()).post {
    result.error("Error", authError?.message, null)
  }
}
private fun resultSuccess(result: Result, success: Any?){
  Handler(Looper.getMainLooper()).post {
    result.success(success)
  }
}
private fun resultAuthorized(result: Result, authorizedResult: AuthorizeResult?){
  resultSuccess(result, authorizedResult?.let {
    mapOf(
      // these are null from amazon for some reason
      "authorizationCode" to it.authorizationCode,
      "clientId" to it.clientId,
      "redirectUri" to it.redirectURI,
      "accessToken" to it.accessToken,
      "user" to it.user?.let { user ->
        mapOf(
          "userEmail" to user.userEmail,
          "userId" to user.userId,
          "userName" to user.userName,
          "userPostalCode" to user.userPostalCode,
          "userInfo" to user.userInfo
        )
      }
    )
  })
}

/**
 * converts a map from dart to a JSONObject
 * **/
private fun jsonFromMap(map: Map<String,Any>): JSONObject = JSONObject().apply {
  map.forEach{item ->
    @Suppress("UNCHECKED_CAST")
    when (item.value){
      is Map<*,*> -> put(item.key, jsonFromMap(item.value as Map<String, Any>))
      else -> put(item.key, item.value)
    }
  }
}

/**
 * converts a map from dart to an amazon scope
 * **/
private fun createScopes(arguments: Map<String, Any>): Array<Scope> =
  arguments.map { scope ->
    @Suppress("UNCHECKED_CAST")
    when(scope.value) {
      is Map<*, *> ->
        ScopeFactory.scopeNamed(scope.key, jsonFromMap(scope.value as Map<String, Any>))
      else -> ScopeFactory.scopeNamed(scope.key)
    }
  }.toTypedArray()


/** FlutterLoginWithAmazonPlugin */
class FlutterLoginWithAmazonPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_login_with_amazon")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
//    if (call.method == "getPlatformVersion") {
//      result.success("Android ${android.os.Build.VERSION.RELEASE}")
//    } else {
//      result.notImplemented()
//    }

    when (call.method){
      "login" -> {
        AuthorizationManager.authorize(
          AuthorizeRequest
          .Builder(createRequestContext(result))
          .addScopes(*createScopes(call.arguments()))
          .build())
      }
      "getAuthCode" -> {
        AuthorizationManager.authorize(
          AuthorizeRequest
          .Builder(createRequestContext(result))
          .addScopes(*createScopes(call.argument("scopes") ?: mapOf()))
          .forGrantType(AuthorizeRequest.GrantType.AUTHORIZATION_CODE)
          .withProofKeyParameters(call.argument("codeChallenge"), call.argument("codeChallengeMethod"))
          .build())
      }
      "getAccessToken" -> {
        AuthorizationManager.getToken(context, createScopes(call.arguments()), object :
          Listener<AuthorizeResult, AuthError> {
          override fun onSuccess(p0: AuthorizeResult?) {
            //this method only returns the accessToken, all other properties are null
            resultSuccess(result, p0?.accessToken)
          }
          override fun onError(p0: AuthError?) {
            resultError(result, p0)
          }
        })
      }
      "logout" -> {
        AuthorizationManager.signOut(context, object : Listener<Void, AuthError> {
          override fun onSuccess(p0: Void?) {
            resultSuccess(result, true)
          }
          override fun onError(p0: AuthError?) {
            resultError(result, p0)
          }
        })
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

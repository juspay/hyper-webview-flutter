/*
 * Copyright (c) Juspay Technologies.
 *
 * This source code is licensed under the AGPL 3.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:developer';
import 'dart:convert';
import 'dart:io' show Platform;

class HyperWebviewFlutter {
  late WebViewController _controller;
  // Bridge Name for Android
  static const HYPER_SDK_BRIDGE = 'HyperWebViewBridge';
  // Bridge Name for IOS platform
  static const HYPER_SDK_BRIDGE_IOS = 'HyperWebViewBridgeIOS';
  static MethodChannel nativeChannel = const MethodChannel("NativeChannel");
  static MethodChannel dartChannel = const MethodChannel("DartChannel");

  // Allowed functions from JS
  List<String> allowedMethods = const [
    'findApps',
    'openApp',
    'getResourceByName',
    'canOpenApp'
  ];

  /// Constructor for plugin class. It creates a channel to send result to webview controller.
  HyperWebviewFlutter() {
    dartChannel.setMethodCallHandler((call) {
      try {
        switch (call.method) {
          case 'onActivityResult':
            Map<String, dynamic> args =
                Map<String, dynamic>.from(call.arguments);
            int requestCode = args['requestCode'] ?? -1;
            int resultCode = args['resultCode'] ?? -1;
            dynamic payload = args['payload'];
            bool isEncoded = args["is_encoded"] ?? false;
            returnResultInWebview(requestCode, resultCode, payload, isEncoded);
          default:
            throw 'Not handled for function ${call.method}';
        }
      } catch (e) {
        log("HyperWebviewFlutter(DartChannel) Error: $e");
      }
      return Future.value(null);
    });
  }

  /// @nodoc
  String sanitizedResultData(dynamic data, bool isEncoded) {
    data = data ?? {};

    if (isEncoded && data is String) {
      Codec<dynamic, String> codec = utf8.fuse(base64);
      data = codec.decode(data);
    }

    // Check if data is a valid JSON string and needs to be encoded
    if (data is String) {
      try {
        // If valid JSON, return as is, no need to jsonEncode again
        jsonDecode(data);
        return data;
      } catch (e) {
        // If not valid JSON, proceed to encode
      }
    }

    return jsonEncode(data);
  }

  /// Function to send result to all iFrames.
  void returnResultInWebview(
      int requestCode, int resultCode, dynamic result, bool isEncoded) {
    String sanitizedData = sanitizedResultData(result, isEncoded);
    String payload = """
      JSON.stringify({
        name: 'onActivityResult',
        payload: JSON.stringify({
          requestCode: '$requestCode',
          resultCode: '$resultCode',
          data: '$sanitizedData'
        })
      })
    """;
    String cmd = """
      try{
        const message = $payload;
        window.postMessage(message,"*");
        const iFrames = document.querySelectorAll('iframe');
        iFrames.forEach(function(iFrame) {
          iFrame.contentWindow.postMessage(message, '*');
        });
      }catch(e){ }
    """;
    _controller.runJavaScript(cmd);
  }

  /// Adds javascript channel to communicate Attaches the Bridge Interfaces.
  /// {@category Required}
  void attach(WebViewController c) {
    _controller = c;
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller.addJavaScriptChannel(
        Platform.isAndroid ? HYPER_SDK_BRIDGE : HYPER_SDK_BRIDGE_IOS,
        onMessageReceived: (message) {
      var data = jsonDecode(message.message);
      var fnName = data['fnName'] as String;
      onErrorCallback() => returnResultInWebview(-1, -1, null, false);
      if (allowedMethods.contains(fnName)) {
        var args = data['args'].cast<dynamic>();
        nativeChannel.invokeMethod(fnName, args).catchError((e) {
          log("HyperWebviewFlutter: attach() Error: $e");
          onErrorCallback();
        });
      } else {
        onErrorCallback();
      }
    });
  }
}

/*
 * Copyright (c) Juspay Technologies.
 *
 * This source code is licensed under the AGPL 3.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'hyper_webview_flutter_platform_interface.dart';

/// An implementation of [HyperWebviewFlutterPlatform] that uses method channels.
class MethodChannelHyperWebviewFlutter extends HyperWebviewFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('hyper_webview_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

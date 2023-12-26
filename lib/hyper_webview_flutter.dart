/*
 * Copyright (c) Juspay Technologies.
 *
 * This source code is licensed under the AGPL 3.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

import 'hyper_webview_flutter_platform_interface.dart';

class HyperWebviewFlutter {
  Future<String?> getPlatformVersion() {
    return HyperWebviewFlutterPlatform.instance.getPlatformVersion();
  }
}

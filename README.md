# Hyper WebView Flutter

A Flutter Plugin that enables UPI Intent App transactions in [Juspay's Paymentpage](https://juspay.in/) inside the Flutter webview widget.

### Flutter Setup

Add flutter plugin dependency in `pubspec.yaml`.
Get dependency from [pub.dev](https://pub.dev/packages/hyper_webview_flutter/install)

## Usage

### Step 1:

Import `hyper_webview_flutter` package in your dart file where WebViewController is being instanciated.

```dart
import 'package:hyper_webview_flutter/hyper_webview_flutter.dart';
```
### Step2:

Instantiate a HyperWebviewFlutter object provided by this plugin.
```dart
HyperWebviewFlutter hyperWebviewFlutterPlugin = HyperWebviewFlutter();
```

### Step 3:

Provide the [webview Controller](https://pub.dev/documentation/webview_flutter/latest/webview_flutter/WebViewController-class.html) to the attach() function of the HyperWebviewFlutter object.

```dart
class _WebviewPaymentPageState extends State<WebviewPaymentPage> {
  late WebViewController _controller;
  @override
  void initState() {
     var url = Uri.parse(widget.url);
    _controller = WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadRequest(url);
    widget.hyperWebviewFlutterPlugin.attach(_controller);
    super.initState();
  }
}
 ```

### Step 4:
Utilize this controller to render the PaymentPage within the WebView.

## License

hyper_webview_flutter is distributed under [AGPL-3.0-only](https://pub.dev/packages/hypersdkflutter/license) license.

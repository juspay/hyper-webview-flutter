# Hyper SDK WebView Flutter
A Flutter Plugin that enables merchants to open [Juspay's Paymentpage](https://juspay.in/) inside the webview widget.
### Flutter Setup

1. Begin by including the Hyper SDK WebView Flutter plugin in your project's pubspec.yaml file. Obtain the necessary dependency [here](https://pub.dev/packages/hyper_webview_flutter
   )
2. Instantiate a HyperWebviewFlutter object provided by this plugin.
3. Provide the [webview Controller](https://pub.dev/documentation/webview_flutter/latest/webview_flutter/WebViewController-class.html) to the attach() function of the HyperWebviewFlutter object.
```
class _WebviewPaymentPageState extends State<WebviewPaymentPage> {
  late WebViewController _controller;
  @override
  void initState() {
     var url = Uri.parse(widget.url);
    _controller = WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadRequest(url);
    widget._hyperWebviewFlutterPlugin = HyperWebviewFlutter();
    widget._hyperWebviewFlutterPlugin.attach(_controller);
    super.initState();
  }
 ```
4. Utilize this controller to render the PaymentPage within the WebView.

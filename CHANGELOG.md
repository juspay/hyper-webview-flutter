## 0.0.6

* Added Swift Package Manager support for iOS. CocoaPods continues to be supported.
* Removed the `canOpenURL` check from `openApp` on iOS, as `canOpenURL` is deprecated in the iOS 27 SDK. The app's URL scheme no longer needs to be listed in `LSApplicationQueriesSchemes` for `openApp`; `canOpenApp` still requires it.

## 0.0.5

* Bug fix where screen gets stuck at loader after completing UPI App txn.

## 0.0.4

* Added ios support for the plugin.

## 0.0.3

* Removed ios support in pubspec.yaml
* Fixed dart warnings


## 0.0.2

* Added Support for Iframe Integration


## 0.0.1

* Added Support for UPI-Intent in Android Webview

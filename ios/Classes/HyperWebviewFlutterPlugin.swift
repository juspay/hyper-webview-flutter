import Flutter

let OPENAPPS_REQUEST_CODE = 19
let GET_RESOURCE_NAME = 453
let CAN_OPEN_APP_CODE = 789

public class HyperWebviewFlutterPlugin: NSObject, FlutterPlugin {
    
    var dartChannel: FlutterMethodChannel?
    var nativeChannel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = HyperWebviewFlutterPlugin()
        instance.dartChannel = FlutterMethodChannel(name: "DartChannel", binaryMessenger: registrar.messenger())
        let channel = FlutterMethodChannel(name: "NativeChannel", binaryMessenger: registrar.messenger())
        instance.nativeChannel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let arguments = call.arguments as? [Any], let resName = arguments.first as? String {
            let resourceVal = getResourceByName(resName)
            let resource: [String: Any] = [
                "requestCode": GET_RESOURCE_NAME,
                "payload": resourceVal
            ]
            dartChannel?.invokeMethod("onActivityResult", arguments: resource)
        }
        if let arguments = call.arguments as? [String]{
            switch call.method {
            case "openApp":
                openApp(arguments.first)
            case "getResourceByName":
                let resourceVal = getResourceByName(arguments.first)
                let resource: [String: Any] = [
                    "requestCode": GET_RESOURCE_NAME,
                    "payload": resourceVal
                ]
                dartChannel?.invokeMethod("onActivityResult", arguments: resource)
            case "canOpenApp":
                canOpenApp(arguments.first)
            default:
                result(FlutterMethodNotImplemented)
                result("true")
            }
        }
    }
   
    /**
    To Check if an app can be opened by the current app
    - Parameter payload: App URL
    */
    func canOpenApp(_ payload: String?) {
        guard let payload = payload, let appURL = URL(string: base64DecodedString(from: payload)) else {
            return
        }
        
        let status = UIApplication.shared.canOpenURL(appURL)
        let resPayload = "{\"result\":\"\(status ? "1" : "0")\",\"app\":\"\(appURL)\"}"
        let resp: [String: Any] = [
            "requestCode": CAN_OPEN_APP_CODE,
            "payload": resPayload
        ]
        dartChannel?.invokeMethod("onActivityResult", arguments: resp)
    }

    func openApp(_ payload: String?) {
        guard let payload = payload, let appURL = URL(string: base64DecodedString(from: payload)) else {
            return
        }
        
        let failedResp: [String: Any] = [
            "requestCode": OPENAPPS_REQUEST_CODE,
            "payload": "false"
        ]
        
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL) { success in
                if success {
                    let successResp: [String: Any] = [
                        "requestCode": OPENAPPS_REQUEST_CODE,
                        "payload": "true"
                    ]
                    self.dartChannel?.invokeMethod("onActivityResult", arguments: successResp)
                } else {
                    self.dartChannel?.invokeMethod("onActivityResult", arguments: failedResp)
                }
            }
        } else {
            dartChannel?.invokeMethod("onActivityResult", arguments: failedResp)
        }
    }

    func getResourceByName(_ resName: String?) -> String {
        var value: String?
        if resName == "CFBundleVersion" {
            value = Bundle(for: type(of: self)).infoDictionary?["hyper_sdk_version"] as? String
        } else {
            value = Bundle(for: type(of: self)).infoDictionary?[resName ?? ""] as? String
        }
        
        return value ?? ""
    }
   
    func base64DecodedString(from input: String?) -> String {
        guard let input = input, let decodedData = Data(base64Encoded: input) else {
            return ""
        }
        return String(data: decodedData, encoding: .utf8) ?? ""
    }
}

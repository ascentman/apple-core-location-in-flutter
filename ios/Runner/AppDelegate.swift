import UIKit
import CoreLocation
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        createChannelForGettingAddress()
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func createChannelForGettingAddress() {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let addressChannel = FlutterMethodChannel(
            name: "volodymyr.rykhva/addressChannel",
            binaryMessenger: controller.binaryMessenger)
        
        addressChannel.setMethodCallHandler({ [weak self]
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard let self = self else {
                result(FlutterError(code: "APP_DELEGATE_NOT_FOUND",
                                    message: "App delegate not found",
                                    details: nil))
                return
            }
            switch call.method {
            case "getAddress":
                guard let args = call.arguments as? [String: Any],
                      let latitude = args["lat"] as? Double,
                      let longitude = args["lon"] as? Double else {
                    result(FlutterError(code: "INVALID_ARGUMENTS",
                                        message: "Invalid arguments",
                                        details: nil))
                    return
                }
                
                self.geocode(latitude: latitude, longitude: longitude) { placemarks, error in
                    if let error = error {
                        result(FlutterError(code: "GEOCODING_ERROR",
                                            message: "Error geocoding location",
                                            details: error.localizedDescription))
                        return
                    }
                    
                    guard let placemarks = placemarks,
                          let firstPlacemark = placemarks.first else {
                        result(nil)
                        return
                    }
                    
                    let addressDetails: [String: String] = [
                        "name": firstPlacemark.name ?? "",
                        "thoroughfare": firstPlacemark.thoroughfare ?? "",
                        "subThoroughfare": firstPlacemark.subThoroughfare ?? "",
                        "locality": firstPlacemark.locality ?? "",
                        "subLocality": firstPlacemark.subLocality ?? "",
                        "administrativeArea": firstPlacemark.administrativeArea ?? "",
                        "subAdministrativeArea": firstPlacemark.subAdministrativeArea ?? "",
                        "postalCode": firstPlacemark.postalCode ?? "",
                        "country": firstPlacemark.country ?? "",
                        "isoCountryCode": firstPlacemark.isoCountryCode ?? ""
                    ]
                    
                    result(addressDetails)
                }
                
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    }
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude), completionHandler: completion)
    }
}

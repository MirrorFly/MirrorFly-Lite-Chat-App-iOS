# [MirrorFlyUIKit](https://www.mirrorfly.com/docs/uikit/ios/quick-start-version-2/) Chat App Sample for iOS

If you're looking for the fastest way in action with CONTUS TECH, then you need to build your app on top of our sample version. Simply download the sample app and commence your app development.
 
## To get the License Key

Step 1: Register [here](https://www.mirrorfly.com/contact-sales.php) to get a MirrorFly User account.

Step 2: [Login](https://console.mirrorfly.com) to your Account

Step 3: Get the License key from the application Info’ section

## License Key Configuration

Use below to configure License key in AppDelegate.

#### License Key Example:
```swift
let licenseKey = "XXXXXXXXXXXXXXXXX"

ChatManager.initializeSDK(licenseKey: licenseKey) { isSuccess, error, data in

}
```

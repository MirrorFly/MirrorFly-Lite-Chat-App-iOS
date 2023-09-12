# MirrorFly Lite Chat App for iOS

MirrorFly Lite Chat App is your new go-to solution for seamless, efficient, and effortless communication.This Lite Chat App, built with our prebuilt UIKit, and ready-made user interface elements that can be seamlessly incorporated for quick chat application development.

Say goodbye to unnecessary clutter and hello to a simplified chat experience that keeps you connected with ease. The below steps help to jumpstart your integration. 

 
## Need a License Key

To integrate the Mirrorfly Lite Chat SDK into your app, you will require a license key. To obtain a license key, follow the below steps;

Step 1: New to MirrorFly? Then register [here](https://www.mirrorfly.com/contact-sales.php) to get a MirrorFly User account.

Step 2: Returning user? Then [Login](https://console.mirrorfly.com) to your MirrorFly user account

Step 3: From the MirrorFly console Overview Page you can find your unique License Key. 

## License Key Configuration

The integration process just involves the license key configuration in the AppDelegate method, that’s it.  Now you can able to build & run the demo app at ease. 

#### License Key Example:
```swift
let licenseKey = "XXXXXXXXXXXXXXXXX"

ChatManager.initializeSDK(licenseKey: licenseKey) { isSuccess, error, data in

}
```
Great. You're now ready to utilize the essential chat features of our Mirrorfly SDK within your application. Now you need to run your app and follow the below steps to initiate chat.

Step 1: Create 2 users with user ID. To send and receive messages between them.

Step 2: Initiate chat, choose a single or group chat,

Step 3: Pick a user from the contact (from the registered user list) and start the conversations.

That is it! It is as simple as it is defined above. Start experiencing MirrorFly’s Lite Chat App for iOS.

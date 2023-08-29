//
//  AppDelegate.swift
//  MirrorflyUIKITSample
//
//  Created by Ramakrishnan on 29/08/23.
//

import UIKit
import MirrorFlySDK
import FlyUIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    let licenseKey = "ckIjaccWBoMNvxdbql8LJ2dmKqT5bp" //"YOUR_LICENSE_KEY"
    
    var notificationView: MFUICustomNotificationView?
    var player: AVAudioPlayer?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       // ChatManager.setAppGroupContainerId(id: "group.com.mirrorfly.qa")
        
        ChatManager.initializeSDK(licenseKey: licenseKey) { isSuccess, error, data in
            if isSuccess{
                print("Success")
                ChatManager.shared.localNotificationDelegate = self
               // FlyDefaults.licenseKey = licenseKey
            }else{
                print(error,"AppdelegateFailed")
            }
        }

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
 @available(iOS 13.0, *)
extension AppDelegate : LocalNotificationDelegate{
    func showOrUpdateOrCancelNotification(jid: String, chatMessage: ChatMessage, groupId: String) {
        
        print("#notification \(chatMessage.chatUserJid) \(groupId) \(chatMessage.senderUserJid)")
        let current = UIApplication.shared.keyWindow?.getTopViewController()
//        if (current is RestoreViewController || current is BackupProgressViewController) {
//            return
//        }
        if ChatManager.onGoingChatUserJid == chatMessage.senderUserJid || (ChatManager.onGoingChatUserJid == groupId  && groupId != "") {
            
            if !CallManager.isOngoingCall() {
                
            }
            
        } else {
            
            var title = "MirrorFly"
            var userId = chatMessage.chatUserJid
            if !groupId.isEmpty{
                userId = chatMessage.senderUserJid
            }
            //let profileDetails = ChatManager.database.rosterManager.getContact(jid: userId)
            let profileDetails = ContactManager.shared.getUserProfileDetails(for: userId)
            let userName =  FlyUtils.getUserName(jid: profileDetails?.jid ?? "0000000000", name: profileDetails?.name ?? "Fly User", nickName: profileDetails?.nickName ?? "Fly User", contactType: profileDetails?.contactType ?? .unknown)
            title = userName
            var message = chatMessage.messageTextContent
            if chatMessage.isMessageRecalled == true {
                message = "This message was deleted"
            } else {
                switch chatMessage.messageType{
                case .text :
                    message = (message.count > 64) ? message : message
                case .notification:
                    if chatMessage.messageChatType == .groupChat {
                        message = (message.count > 64) ? message : message
                    }
                default :
                    message = chatMessage.messageType.rawValue.capitalized
                }
            }
            var isCarbon = false
            if FlyDefaults.hideNotificationContent{
                let (messageCount, chatCount) = ChatManager.getUNreadMessageAndChatCount()
                var titleContent = emptyString()
                if chatCount == 1{
                    titleContent = "\(messageCount) \(messageCount == 1 ? "message" : "messages")"
                }else{
                    titleContent = "\(messageCount) messages from \(chatCount) chats"
                }
                title = FlyDefaults.appName + " (\(titleContent))"
                message = "New Message"
            }else{
                if groupId.isEmpty{
                    title = userName
                }else{
                    //let profileDetails = ChatManager.database.rosterManager.getContact(jid: groupId)
                    let profileDetails = ContactManager.shared.getUserProfileDetails(for: groupId)
                    title = "\(title) @ \(profileDetails?.name ?? "Fly Group ")"
                }
            }
            
            if chatMessage.senderUserJid == FlyDefaults.myJid{
                isCarbon = true
            }
            if isCarbon {
                message = "Duplicate message"
            }
            
            if !chatMessage.mentionedUsersIds.isEmpty {
                message = ChatUtils.getMentionTextContent(message: message, isMessageSentByMe: chatMessage.isMessageSentByMe, mentionedUsers: chatMessage.mentionedUsersIds).string
            }

            executeOnMainThread {
                self.showCustomNotificationView(title: title , message: message, chatMessage: chatMessage)
            }
        }
    }
    
    
}

extension UIWindow {
    func getTopViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
      if let mainNC = top as? UINavigationController ,let mainVC = mainNC.visibleViewController {
            return mainVC
        }
        return top
    }
}

@available(iOS 13.0, *)
extension AppDelegate {
    
    func showCustomNotificationView(title: String, message: String, chatMessage: Any? = nil) {
        
        if self.notificationView != nil {
            self.notificationView?.removeFromSuperview()
        }
        
        let window = UIApplication.shared.keyWindow!
        
        let view = MFUICustomNotificationView()
        
        view.frame = CGRect(x: 10, y: window.safeAreaInsets.top - 130, width: (window.bounds.width) - 20, height: 70)
        view.titleLabel.text = title
        view.messageLabel.text = message
        view.accessibilityElements = [chatMessage as Any]
        view.logoImg.applyShadow(1.0, shawdowOpacity: 0.2)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleUpSwipe(_:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(swipeUp)
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 3.0
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.masksToBounds = false
        
        window.addSubview(view)
        notificationView = view
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            if !CallManager.isOngoingCall() {
                
                self.playSound()
                
                if FlyDefaults.vibrationEnable {
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            }
            
        }
        
        UIView.animate(withDuration: 0.5) {
            view.frame = CGRect(x: 10, y:   window.safeAreaInsets.top, width: (window.bounds.width) - 20, height: 70)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            UIView.animate(withDuration: 0.3, delay: 0, options: .transitionFlipFromTop, animations:  {
                view.frame = CGRect(x: 10, y:  window.safeAreaInsets.top - 130, width: (window.bounds.width) - 20, height: 70)
            },completion: {_ in })
        })
    }
    
    
    @objc func handleUpSwipe(_ recognizer: UISwipeGestureRecognizer) {
        
        print("Swiped on a Notification View")
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionFlipFromTop, animations:  {
            
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            
            self.notificationView?.frame = CGRect(x: 10, y:  window.safeAreaInsets.top - 130, width:window.frame.width - 20, height: 70)
            
        },completion: {_ in
            self.notificationView?.removeFromSuperview()
        })
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer?) {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true)
        let current = UIApplication.shared.keyWindow?.getTopViewController()
        //            if (current is ProfileViewController) {
        //                return
        //            }
        if (current is MFUICallScreenViewController) {
            (current as! MFUICallScreenViewController).showCallOverlay()
        }
        
        //Redirect to chat page
        if let message = (sender?.view?.accessibilityElements as? [ChatMessage])?.first {
            
            print("Tap on a Notification View \(message)")
            
            if FlyDefaults.isBlockedByAdmin {
                // navigateToBlockedScreen()
            } else {
                let messageId = message.messageId
                if let message = FlyMessenger.getMessageOfId(messageId: messageId) {
                    pushChatId = message.chatUserJid
                    
                    if !FlyDefaults.showAppLock {
                        pushChatId = nil
                        navigateToChatScreen(chatId: message.chatUserJid , message: message, completionHandler: {})
                    }
                }
            }
        }
    }
    func playSound() {
        
        if !(FlyDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("None") ?? false) && FlyDefaults.notificationSoundEnable {
            
            guard let path = Bundle.main.path(forResource: "notification-tone", ofType:"mp3") else {
                return }
            let url = URL(fileURLWithPath: path)

            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.soloAmbient, options: AVAudioSession.CategoryOptions.mixWithOthers)
                try AVAudioSession.sharedInstance().setActive(true)
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
                player?.volume = 1.0
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

func navigateToChatScreen(chatId : String, message : ChatMessage,completionHandler: @escaping () -> Void){
    var dismisLastViewController = false
    let recentChatListViewController = MFUIRecentChatListViewController()
//        recentChatListViewController.isInitialLoading = true
    UIApplication.shared.keyWindow?.rootViewController =  UINavigationController(rootViewController: recentChatListViewController)
    UIApplication.shared.keyWindow?.makeKeyAndVisible()
    if let rootVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
        if let currentVC = rootVC.children.last, currentVC.isKind(of: MFUIChatViewParentController.self){
            dismisLastViewController = true
        }
        if dismisLastViewController{
            rootVC.popViewController(animated: false)
        }
        if let profileDetails = ContactManager.shared.getUserProfileDetails(for: chatId) , (chatId) != FlyDefaults.myJid{
            let vc = MFUIChatViewParentController(chatMessage: message, chatJid: chatId, messageMenItem: .reply)
            vc.showLoading(false, isContact: false)
            rootVC.removeViewController(MFUIChatViewParentController.self)
            rootVC.pushViewController(vc, animated: false)
        }
    }

}
}

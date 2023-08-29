//
//  ViewController.swift
//  MirrorflyUIKITSample
//
//  Created by Ramakrishnan on 29/08/23.
//

import UIKit
import FlyUIKit

class ViewController: UIViewController {

    var userID = "" //Your User ID
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func initialize(_ sender: Any) {
        initialize()
    }
   
    
    
    func initialize () {

        FlyUIKitSDK.shared.initialization(userID: userID, isExport: false) { isSuccess, error in
            if isSuccess{
                FlyUIKitConstants.IS_CALL_ENABLED = false
                self.getRecentChat()
            } else {
                print(error)
            }
        }
        
    }

    func getRecentChat() {
        let recentChatListViewController = MFUIRecentChatListViewController()
        recentChatListViewController.isInitialLoading = true
        recentChatListViewController.showCreateOptionOf(chat: true, group: true, setting: false)
        self.navigationController?.pushViewController(recentChatListViewController, animated: true)
    }
    
   

}


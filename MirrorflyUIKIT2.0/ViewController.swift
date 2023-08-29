//
//  ViewController.swift
//  MirrorflyUIKIT2.0
//
//  Created by Ramakrishnan on 21/08/23.
//

import UIKit
import FlyUIKit



class ViewController: UIViewController {

    var userID = "" //Your User ID
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func initializeSdk(_ sender: Any) {
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
        self.navigationController?.pushViewController(recentChatListViewController, animated: true)
    }
    
   

}


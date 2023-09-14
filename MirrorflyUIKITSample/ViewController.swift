//
//  ViewController.swift
//  MirrorflyUIKITSample
//
//  Created by Ramakrishnan on 29/08/23.
//

import UIKit
import MirrorFlySDK
import FlyUIKit
import Toaster


class ViewController: UIViewController, UITextFieldDelegate {
    
    
    var ISEXPORT = false
    
    @IBOutlet weak var logoutBtn: UIButton!
   
   
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var openChatButton: UIButton!
    @IBOutlet weak var initLabel: UILabel!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.openChatButton.layer.cornerRadius = 18
        self.openChatButton.backgroundColor = .blue
        activityIndicator.isHidden = true
        self.phoneNumberTextField.delegate = self
        self.phoneNumberTextField.keyboardType = .default
        if UserDefaults.standard.isLoggedIn() {
            phoneNumberTextField.text = UserDefaults.standard.getUserID()
            phoneNumberTextField.isUserInteractionEnabled = false
            initialize()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.openChatButton.isHidden = false
        self.activityIndicator.isHidden = true
        self.initLabel.isHidden = true
        self.activityIndicator.stopAnimating()
    }
        
    func initialize () {
        FlyUIKitConstants.IS_CALL_ENABLED = false
        FlyUIKitConstants.isChatTranslate = false
        if #available(iOS 13.0, *) {
            FlyUIKitSDK.shared.initialization(userID : phoneNumberTextField.text ?? "", isExport: ISEXPORT, selfObj: nil) {(isSuccess, error) in
                self.activityIndicator.stopAnimating()
                if isSuccess{
                    UserDefaults.standard.setLoggedIn(value: true)
                    UserDefaults.standard.setUserID(value: self.phoneNumberTextField.text ?? "")
                    self.getRecentChat()
                } else {
                    print(error)
                }
            }
        } else {
            FlyUIKitSDK.shared.initialization(userID: phoneNumberTextField.text ?? "", isExport: ISEXPORT, selfObj: nil) {(isSuccess, error) in
                self.activityIndicator.stopAnimating()
                if isSuccess{
                    UserDefaults.standard.setLoggedIn(value: true)
                    UserDefaults.standard.setUserID(value: self.phoneNumberTextField.text ?? "")
                    self.getRecentChat()
                } else {
                    print(error)
                }
            }
        }
    }
    
    func getRecentChat() {
        FlyUIKitConstants.IS_CALL_ENABLED = false
       
        let recentChatListViewController = MFUIRecentChatListViewController()
        recentChatListViewController.isInitialLoading = true
        recentChatListViewController.showCreateOptionOf(chat: true, group: true, setting: true)
        self.navigationController?.pushViewController(recentChatListViewController, animated: true)
    }
    
    @IBAction func openChat(_ sender: Any) {
        
        if phoneNumberTextField.text?.isEmpty ?? false {
            
            Toast(text: "Please Enter Your User ID").show()
        }

        else {
            if appDelegate.validLicensekey {
                phoneNumberTextField.resignFirstResponder()
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                self.openChatButton.isHidden = true
                self.initLabel.isHidden = false
                self.initialize()
                
            } else {
                Toast(text: "Please Enter Valid LicenseKey").show()
                self.activityIndicator.isHidden = true
                self.openChatButton.isHidden = false
                self.initLabel.isHidden = true
                phoneNumberTextField.resignFirstResponder()
                
            }
           
        }
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    
    @IBAction func didClickLogoutBtn(_ sender: UIButton) {
        UserDefaults.standard.setLoggedIn(value: false)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        return (string == filtered)
        
    }
    
   
}


extension UserDefaults{

    //MARK: Check Login
    func setLoggedIn(value: Bool) {
        set(value, forKey: "isLoggedIn")
        //synchronize()
    }
    
    func isLoggedIn()-> Bool {
        return bool(forKey: "isLoggedIn")
    }
    

    func getUserID()-> Bool {
        return bool(forKey: "isLoggedIn")
    }

    //MARK: Save User Data
    func setUserID(value: String){
        set(value, forKey: "userID")
        //synchronize()
    }

    //MARK: Retrieve User Data
    func getUserID() -> String{
        return string(forKey: "userID") ?? ""
    }
}

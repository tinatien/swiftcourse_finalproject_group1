//
//  LoginViewController.swift
//  Fang0
//
//  Created by Chun Tie Lin on 2016/3/23.
//  Copyright © 2016年 TinaTien. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Alamofire
import FBSDKShareKit

var acceptToken: String!
var fbAccessToken: String!
var userDefaultToken: String?

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var logoView: UIView!
    
    var resultDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            //FBSDK按鈕
            self.logoView.hidden = false
            
//            let fbToken = FBSDKAccessToken.currentAccessToken().tokenString
            
//            let parameters = ["fbtoken": fbToken]
            
//            Alamofire.request(.POST, "http://140.119.19.13:30080/users", parameters: parameters, encoding: .JSON).responseJSON { response in
//                if let JSON = response.result.value {
//                    self.resultDictionary = JSON as! NSDictionary
//                    acceptToken = self.resultDictionary["token"] as? String
//                    self.userDefault.setValue(acceptToken as String, forKey: "token")
//                    self.dismissViewControllerAnimated(true, completion: nil)
//                }
//            }
            
        } else {
            self.logoView.hidden = true
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends","user_posts", "user_photos"]
            loginView.publishPermissions = ["publish_actions"]
            loginView.delegate = self
            
            print ("fail")
        }
        
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if let accessToken = FBSDKAccessToken.currentAccessToken() {
            print(accessToken)
        } else {
            print("Not logged In.")
        }
        return true
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        
        let fbToken = FBSDKAccessToken.currentAccessToken().tokenString
        
        let parameters = ["fbtoken": fbToken]
        Alamofire.request(.POST, "http://140.119.19.13:30080/users", parameters: parameters, encoding: .JSON).responseJSON { response in
            if let JSON = response.result.value {
                self.resultDictionary = JSON as! NSDictionary
                acceptToken = self.resultDictionary["token"] as? String
                NSUserDefaults.standardUserDefaults().setObject(acceptToken, forKey: "token")
            }
        }
        
        NSUserDefaults.standardUserDefaults().setObject(fbToken, forKey: "fbToken")
        NSUserDefaults.standardUserDefaults().synchronize()
        print("User Logged In")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,sender: AnyObject?) {
        if segue.identifier == "showLogin" {
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        print("User Logged Out")
        
    }
}
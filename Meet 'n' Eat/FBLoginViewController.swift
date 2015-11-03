//
//  ViewController.swift
//  Meet 'n' Eat
//
//  Created by Narcis Zait on 26/10/15.
//  Copyright © 2015 Narcis Zait. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import Parse
import ParseFacebookUtilsV4

class FBLoginViewController: UIViewController { //FBSDKLoginButtonDelegate
    
    let defaults = NSUserDefaults.standardUserDefaults();
    let successVC = SuccessViewController();
    
//    @IBOutlet weak var fbButton: FBSDKLoginButton!;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        fbButton.readPermissions = ["public_profile", "email", "user_friends"];
//        fbButton.delegate = self
    }
    
    
    @IBAction func facebookLogin(sender: AnyObject) {
//        let login: FBSDKLoginManager = FBSDKLoginManager();
//        login.logInWithReadPermissions(["public_profile", "email", "user_friends"], handler:{ (result, error) -> Void in
//            if ((error) != nil)
//            {
//                // Process error
//                print("Error Somewhere!!");
//            }
//            else if result.isCancelled {
//                // Handle cancellations
//                print("Cancelled Somewhere!!");
//            }
//            else {
//                self.defaults.setBool(true, forKey: "FBLoggedIn");
//                print("nsdefaults set");
//                self.performSegueWithIdentifier("success_page", sender: self);
////                self.presentViewController(self.successVC, animated: true, completion: nil)
//                print("perform seque")
//            }
//        });
        print("hello");
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email"], block: { (user: PFUser?, error:NSError?) -> Void in
            print("block")
            
            if (error != nil) {
                print(error?.localizedDescription);
                let alert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: .Alert);
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil);
                alert.addAction(okAction);
                self.presentViewController(alert, animated: true, completion: nil);
                return
            } else {
                print("user object: \(user!)");
                print("user name: \(FBSDKAccessToken.currentAccessToken().userID)")
                self.defaults.setBool(true, forKey: "FBLoggedIn");
                print("nsdefaults set");
                self.performSegueWithIdentifier("success_page", sender: self);
                print("perform seque");
            }
        });

        
//        let permissions = ["public_profile", "email", "user_friends"]
//        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
//            (user: PFUser?, error: NSError?) -> Void in
//            if let user = user {
//                if user.isNew {
//                    print("User signed up and logged in through Facebook!")
//                } else {
//                    print("User logged in through Facebook!")
//                }
//            } else {
//                print("Uh oh. The user cancelled the Facebook login.")
//            }
//        }
      }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
//        if (error == nil) {
//            self.defaults.setBool(true, forKey: "FBLoggedIn");
//            print("nsdefaults set");
//            
//            print("result: \(result)")
//            
//            self.performSegueWithIdentifier("success_page", sender: self);
//            print("perform seque")
//        } else {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
//        print("User logged out")
//    }
}


//
//  LoginViewController.swift
//  Meet 'n' Eat
//
//  Created by Narcis Zait on 03/11/15.
//  Copyright © 2015 Narcis Zait. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import Parse
import ParseFacebookUtilsV4
import ParseUI

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var fbLoginButton: UIButton!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view.
        if (PFUser.currentUser() != nil) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home");
                self.presentViewController(viewController, animated: true, completion: nil);
            });
        } else {
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func fbLogin(sender: AnyObject) {
        print("facebook facebook facebook");
        
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
                let requestParameters = ["fields": "id, email, name, gender"];
                let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters);
                userDetails.startWithCompletionHandler { (connection, result, error: NSError!) -> Void in
                    if (error != nil) {
                        print(error.localizedDescription);
                        return ;
                    } else {
                        if (result != nil){
                            let userID: AnyObject! = result["id"];
                            
                            let facebookUser: PFUser = PFUser.currentUser()!;
                            facebookUser.setObject(result["name"], forKey: "Name");
                            facebookUser.setObject(result["name"], forKey: "username");
                            facebookUser.setObject(result["id"], forKey: "objectId");
                            facebookUser.setObject(result["email"], forKey: "email");
                            facebookUser.setObject("1", forKey: "Hobbies");
                            
                            let avatarLocationURL = NSURL(string: "https://graph.facebook.com/\(userID)/picture?width=1000&height=1000");
                            let profilePictureData = NSData(contentsOfURL: avatarLocationURL!);
                            let profileFileObject = PFFile(name: "Profile Image.png", data: profilePictureData!);
                            facebookUser.setObject(profileFileObject!, forKey: "ProfilePic")
                            facebookUser.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                                if (error == nil){
                                    print("success");
                                } else {
                                    print(error!.localizedDescription);
                                }
                            })
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Quiz");
                    self.presentViewController(viewController, animated: true, completion: nil);
                })
            }
        });
    }
    
    @IBAction override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

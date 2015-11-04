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
            })
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func fbLogin(sender: AnyObject) {
        print("facebook facebook facebook");
        
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

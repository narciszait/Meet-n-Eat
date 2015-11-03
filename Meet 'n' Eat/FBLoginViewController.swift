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
import ParseUI

class FBLoginViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    let defaults = NSUserDefaults.standardUserDefaults();
    

    override func viewDidLoad() {
        super.viewDidLoad();
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (PFUser.currentUser() == nil){
            let loginViewController = LoginViewController();
            loginViewController.delegate = self;
            loginViewController.fields = [.UsernameAndPassword, .LogInButton, .PasswordForgotten, .SignUpButton, .Facebook];
            loginViewController.emailAsUsername = true;
            loginViewController.signUpController?.emailAsUsername = true;
            loginViewController.signUpController?.delegate = self;
            self.presentViewController(loginViewController, animated: false, completion: nil);
        } else {
            self.loggedIn();
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Parse Built-in login function
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(false, completion: nil);
        self.loggedIn();
    }
    
    //Parse Built-in sign up function
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(false, completion: nil);
        self.loggedIn();
    }
    
    //transition to the next screen
    func loggedIn(){
        self.performSegueWithIdentifier("loggedIn", sender: self);
    }
    

}


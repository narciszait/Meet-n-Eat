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

class LoginViewController : PFLogInViewController {
    
    var backgroundImage : UIImageView!;
    var viewsToAnimate: [UIView!]!;
    var viewsFinalYPosition: [CGFloat]!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // set our custom background image
        backgroundImage = UIImageView(image: UIImage(named: "welcome_5"));
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill;
        self.logInView!.insertSubview(backgroundImage, atIndex: 0);
        
        //custom Logo
        let logo = UILabel();
        logo.text = "Meet 'n' Eat";
        logo.textColor = UIColor.whiteColor();
        logo.font = UIFont(name: "Pacifico", size: 70);
        logo.shadowColor = UIColor.lightGrayColor();
        logo.shadowOffset = CGSizeMake(2, 2);
        logInView?.logo = logo;
        
        //Login Button changind color
        logInView?.logInButton?.setBackgroundImage(nil, forState: .Normal);
        logInView?.logInButton?.backgroundColor = UIColor(red: 52 / 255, green: 191 / 255, blue: 73 / 255, alpha: 1.0)
        
        //Forgot password button
        logInView?.passwordForgottenButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal);
        logInView?.passwordForgottenButton?.backgroundColor = UIColor(red: 52 / 255, green: 191 / 255, blue: 73 / 255, alpha: 1.0)
        
        //Facebook, signup buttons recoloring
        customizeButton(logInView?.facebookButton!);
        customizeButton(logInView?.signUpButton!);
        customizeButton(logInView?.passwordForgottenButton!);
        
        //animation
        viewsToAnimate = [self.logInView?.usernameField, self.logInView?.passwordField, self.logInView?.logInButton, self.logInView?.passwordForgottenButton, self.logInView?.facebookButton, self.logInView?.signUpButton, self.logInView?.logo];
        
        //custom SignUpViewController
        self.signUpController = SignUpViewController()
//        self.signUpController!.emailAsUsername = true;
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        // stretch background image to fill screen
        backgroundImage.frame = CGRectMake( 0,  0,  self.logInView!.frame.width,  self.logInView!.frame.height);
        
        //position logo
        logInView!.logo!.sizeToFit();
        let logoFrame = logInView!.logo!.frame;
        logInView!.logo!.frame = CGRectMake(logoFrame.origin.x, logInView!.usernameField!.frame.origin.y - logoFrame.height - 16, logInView!.frame.width,  logoFrame.height);
        
        //animate
        viewsFinalYPosition = [CGFloat]();
        for viewToAnimate in viewsToAnimate {
            let currentFrame = viewToAnimate.frame;
            viewsFinalYPosition.append(currentFrame.origin.y);
            viewToAnimate.frame = CGRectMake(currentFrame.origin.x, self.view.frame.height + currentFrame .origin.y, currentFrame.width, currentFrame.height);
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        if viewsFinalYPosition.count == self.viewsToAnimate.count {
            UIView.animateWithDuration(1, delay: 0.0, options: .CurveEaseInOut,  animations: { () -> Void in
                for viewToAnimate in self.viewsToAnimate {
                    //viewToAnimate.alpha = 1
                    let currentFrame = viewToAnimate.frame
                    viewToAnimate.frame = CGRectMake(currentFrame.origin.x, self.viewsFinalYPosition.removeAtIndex(0), currentFrame.width, currentFrame.height)
                    }
                }, completion: nil)
        }
        self.signUpController = SignUpViewController();
    }
    
    func customizeButton(button: UIButton!){
        button.setBackgroundImage(nil, forState: .Normal);
        button.backgroundColor = UIColor.clearColor();
        button.layer.cornerRadius = 10;
        button.layer.borderColor = UIColor.whiteColor().CGColor;
        button.layer.borderWidth = 1
    }
    
}
//
//  SignUpViewController.swift
//  Meet 'n' Eat
//
//  Created by Narcis Zait on 03/11/15.
//  Copyright © 2015 Narcis Zait. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI

class SignUpViewController: PFSignUpViewController {
    var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //set background image
        backgroundImage = UIImageView(image: UIImage(named: "welcome_5"));
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill;
        signUpView!.insertSubview(backgroundImage, atIndex: 0);
        
        //logo
        let logo = UILabel();
        logo.text = "Meet 'n' Eat";
        logo.textColor = UIColor.whiteColor();
        logo.font = UIFont(name: "Pacifico", size: 70);
        logo.shadowColor = UIColor.lightGrayColor();
        logo.shadowOffset = CGSizeMake(2, 2);
        signUpView?.logo = logo;
        
        self.modalTransitionStyle = .FlipHorizontal;
        signUpView?.emailAsUsername = true;
        
        signUpView?.signUpButton?.setBackgroundImage(nil, forState: .Normal);
        signUpView?.signUpButton?.backgroundColor = UIColor(red: 52 / 255, green: 191 / 255, blue: 73 / 255, alpha: 1.0);
        
        signUpView?.dismissButton!.setTitle("Already signed up?", forState: .Normal);
        signUpView?.dismissButton!.setImage(nil, forState: .Normal);
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // stretch background image to fill screen
        backgroundImage.frame = CGRectMake( 0,  0,  signUpView!.frame.width,  signUpView!.frame.height)
        
        // position logo at top with larger frame
        signUpView!.logo!.sizeToFit()
        let logoFrame = signUpView!.logo!.frame
        signUpView!.logo!.frame = CGRectMake(logoFrame.origin.x, signUpView!.usernameField!.frame.origin.y - logoFrame.height - 16, signUpView!.frame.width,  logoFrame.height)
        
        // re-layout out dismiss button to be below sign
        let dismissButtonFrame = signUpView!.dismissButton!.frame
        signUpView?.dismissButton!.frame = CGRectMake(0, signUpView!.signUpButton!.frame.origin.y + signUpView!.signUpButton!.frame.height + 16.0,  signUpView!.frame.width,  dismissButtonFrame.height)
        
    }
}
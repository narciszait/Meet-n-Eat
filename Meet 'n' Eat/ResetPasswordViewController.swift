//
//  SuccessViewController.swift
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


class ResetPasswordViewController: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var emailField: UITextField!;
    var currentResponder: AnyObject?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.emailField.delegate = self;
        
        let singleTap = UITapGestureRecognizer(target: self, action: "resignOnTap:");
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        self.view.addGestureRecognizer(singleTap);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func passwordReset(sender: AnyObject){
        let email = self.emailField.text;
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
        PFUser.requestPasswordResetForEmailInBackground(finalEmail);
        
        let alert = UIAlertController(title: "Password Reset", message: "An email containing the password has been send", preferredStyle: .Alert);
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil));
        self.presentViewController(alert, animated: true, completion: nil);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.emailField) {
            self.emailField.resignFirstResponder();
        }
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentResponder = textField;
    }
    
    func resignOnTap(sender: AnyObject){
        self.currentResponder?.resignFirstResponder();
    }
    
    @IBAction override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        let destination = unwindSegue.destinationViewController
        destination.transitioningDelegate = self
        print("unwind");
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return StarWarsGLAnimator()
    }
    
}

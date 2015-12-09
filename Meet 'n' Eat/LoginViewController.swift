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

class LoginViewController: UIViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    
    
    @IBOutlet weak var fbLoginButton: UIButton!;
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var currentResponder: AnyObject?;
    
    var container: UIView!;
    var loadingView: UIView!;
    var spinner: UIActivityIndicatorView!;

    
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
        
        emailField.delegate = self;
        passwordField.delegate = self;
        
        let singleTap = UITapGestureRecognizer(target: self, action: "resignOnTap:");
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        self.view.addGestureRecognizer(singleTap);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.emailField) {
            self.passwordField.becomeFirstResponder();
        } else if (textField == self.passwordField) {
            self.passwordField.resignFirstResponder();
        }
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentResponder = textField;
    }
    
    func resignOnTap(sender: AnyObject){
        self.currentResponder?.resignFirstResponder();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func fbLogin(sender: AnyObject) {
        print("facebook facebook facebook");
        
        if (PFUser.currentUser() != nil) {
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home");
                self.presentViewController(viewController, animated: true, completion: nil);
//            });
            
        } else {
        
            PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email"], block: { (user: PFUser?, error:NSError?) -> Void in
            
                if (error != nil) {
                    print(error?.localizedDescription);
                    let alert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: .Alert);
                    let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil);
                    alert.addAction(okAction);
                    self.presentViewController(alert, animated: true, completion: nil);
                    return ;
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
                    });
                }
            });
        }
    }
    
    @IBAction func loginAction(sender: AnyObject){
        let username = self.emailField.text;
        let password = self.passwordField.text;
        
        //Validate the text fields
        if (username?.characters.count < 1){
            let alert = UIAlertView(title: "Invalid", message: "Email cannot be blank", delegate: self, cancelButtonTitle: "OK");
            alert.show();
        } else if (password?.characters.count < 1) {
            let alert = UIAlertView(title: "Invalid", message: "Password cannot be blank", delegate: self, cancelButtonTitle: "OK");
            alert.show();
        } else {
            //show spinner with a fade out animation
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.view.alpha = 0.75;
                }, completion: { (success) -> Void in
                    self.showActivityIndicatory(self.view);
                    self.container.alpha = 1.0;
                    
                    //Send login request
                    PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
                        //stop the spinner
                        self.spinner.stopAnimating();
                        self.container.removeFromSuperview();
                        
                        if ((user) != nil) {
                            let alert = UIAlertView(title: "Success", message: "Logged in", delegate: self, cancelButtonTitle: "OK");
                            alert.show();
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home");
                                self.presentViewController(viewController, animated: true, completion: nil);
                            });
                        } else {
                            let alert = UIAlertView(title: "Error", message: "\(error?.localizedDescription)", delegate: self, cancelButtonTitle: "OK");
                            alert.show()
                        }
                    });
            });
            
//            //Send login request
//            PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
//                //stop the spinner
//                self.spinner.stopAnimating();
//                self.container.removeFromSuperview();
//                
//                if ((user) != nil) {
//                    let alert = UIAlertView(title: "Success", message: "Logged in", delegate: self, cancelButtonTitle: "OK");
//                    alert.show();
//                    
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home");
//                        self.presentViewController(viewController, animated: true, completion: nil);
//                    });
//                } else {
//                    let alert = UIAlertView(title: "Error", message: "\(error?.localizedDescription)", delegate: self, cancelButtonTitle: "OK");
//                    alert.show()
//                }
//            });
            
        }
    }
    
    @IBAction override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
    //setup the spinner
    func showActivityIndicatory(uiView: UIView) {
        //let container: UIView = UIView()
        container = UIView();
        container.frame = uiView.frame;
        container.center = uiView.center;
        container.backgroundColor = UIColor.clearColor();
        container.alpha = 0.3;
        
        //let loadingView: UIView = UIView()
        loadingView = UIView();
        loadingView.frame = CGRectMake(0, 0, 80, 80);
        loadingView.center = uiView.center;
        loadingView.backgroundColor = UIColor.grayColor(); //FromHex(0x444444, alpha: 0.7)
        loadingView.alpha = 0.7;
        loadingView.clipsToBounds = true;
        loadingView.layer.cornerRadius = 10;
        
        //let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        spinner = UIActivityIndicatorView();
        spinner.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge;
        spinner.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
        loadingView.addSubview(spinner);
        container.addSubview(loadingView);
        uiView.addSubview(container);
        spinner.startAnimating();
    }

    
    
    // MARK: Emergency button
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverSegue" {
            let emergencyViewController = segue.destinationViewController as! EmergencyViewController;
            emergencyViewController.modalPresentationStyle = UIModalPresentationStyle.Popover;
            emergencyViewController.popoverPresentationController!.delegate = self;
            emergencyViewController.popoverPresentationController?.sourceRect = CGRectMake(100, 30, 0, 0);
            emergencyViewController.popoverPresentationController?.permittedArrowDirections = [.Up];
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None;
    }

    
}

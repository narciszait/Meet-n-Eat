//
//  ContinueSignUpViewController.swift
//  Meet 'n' Eat
//
//  Created by Narcis Zait on 04/11/15.
//  Copyright © 2015 Narcis Zait. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!;
    @IBOutlet weak var emailField: UITextField!;
    @IBOutlet weak var passwordField: UITextField!;
    @IBOutlet weak var profilePhoto: UIImageView!;
    var currentResponder: AnyObject?;
    var container: UIView!;
    var loadingView: UIView!;
    var spinner: UIActivityIndicatorView!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameField.delegate = self;
        emailField.delegate = self;
        passwordField.delegate = self;
        
        let singleTap = UITapGestureRecognizer(target: self, action: "resignOnTap:");
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        self.view.addGestureRecognizer(singleTap);
        
        print("self.view.x: \(self.view.frame.origin.x)");
        
        self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.width / 2;
        self.profilePhoto.clipsToBounds = true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.nameField) {
            self.emailField.becomeFirstResponder();
        } else if (textField == self.emailField) {
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
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder();
//        return true;
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    @IBAction func signUp(sender: AnyObject){
        let name = self.nameField.text;
        let email = self.emailField.text;
        let password = self.passwordField.text;
        
        //Validate text fields
        if (name!.characters.count < 0) {
            let alert = UIAlertView(title: "Invalid", message: "Name cannot be blank", delegate: self, cancelButtonTitle: "OK");
            alert.show();
        } else if (email!.characters.count < 0) {
            let alert = UIAlertView(title: "Invalid", message: "Email cannot be blank", delegate: self, cancelButtonTitle: "OK");
            alert.show();
        } else if (password?.characters.count < 0){
            let alert = UIAlertView(title: "Invalid", message: "Password cannot be blank", delegate: self, cancelButtonTitle: "OK");
            alert.show();
        } else {
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.view.alpha = 0.75;
                }, completion: { (success) -> Void in
                    self.showActivityIndicatory(self.view);
                    self.container.alpha = 1.0;
            });
            
//            self.view.addSubview(spinner);
//            spinner.activityIndicatorViewStyle = .WhiteLarge
//            UIView.animateWithDuration(1.0, animations: { () -> Void in
//                self.view.alpha = 0.75;
//                spinner.alpha = 1.0;
//            });
//            spinner.startAnimating();

            let imageData: NSData = UIImageJPEGRepresentation(profilePhoto.image!, 50.0)!; // UIImagePNGRepresentation(profilePhoto.image!)!; //
            let imageFile = PFFile(name: "Profile Image.png", data: imageData)
            
//            imageFile?.saveInBackgroundWithBlock({ (success, error) -> Void in
//                if (error == nil) {
//                    let newUser = PFUser();
//                    newUser.username = name;
//                    newUser.setValue(name, forKey: "Name");
//                    newUser.email = email;
//                    newUser.password = password;
//                    newUser.setObject(imageFile!, forKey: "ProfilePic");
//                    newUser.saveInBackground();
//                    
//                    //sign up asynchronously
//                    newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
//                        //stop the spinner
//                        spinner.stopAnimating();
//                        if ((error) != nil){
//                            let alert = UIAlertView(title: "Error", message: "\(error?.localizedDescription)", delegate: self, cancelButtonTitle: "OK");
//                            alert.show();
//                        } else {
//                            let alert = UIAlertView(title: "Success", message: "Signed up", delegate: self, cancelButtonTitle: "OK");
//                            alert.show();
//                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home");
//                                self.presentViewController(viewController, animated: true, completion: nil);
//                            });
//                        }
//                    });
//
//                }
//            });
            
            let newUser = PFUser();
            newUser.username = name;
            newUser.setValue(name, forKey: "Name");
            newUser.email = email;
            newUser.password = password;
            newUser.setObject(imageFile!, forKey: "ProfilePic");
            newUser.setObject([], forKey: "Hobbies");
            newUser.saveInBackground();
            
            
            
            //sign up asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                //stop the spinner
                self.spinner.stopAnimating();
                self.container.removeFromSuperview();
                if ((error) != nil){
                    let alert = UIAlertView(title: "Error", message: "\(error?.localizedDescription)", delegate: self, cancelButtonTitle: "OK");
                    alert.show();
                } else {
                    let alert = UIAlertView(title: "Quiz time", message: "On to quiz", delegate: self, cancelButtonTitle: "Go!");
                    alert.show();
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Quiz");
                        self.presentViewController(viewController, animated: true, completion: nil);
                    });
                }
            });
        }
    }
    
    @IBAction func selectProfilePhoto(sender: AnyObject){
        let imagePickerController = UIImagePickerController();
        imagePickerController.delegate = self;
        imagePickerController.sourceType = .PhotoLibrary;
        self.presentViewController(imagePickerController, animated: true, completion: nil);
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        profilePhoto.image = info[UIImagePickerControllerOriginalImage] as? UIImage;
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}

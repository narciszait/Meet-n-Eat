//
//  ContinueSignUpViewController.swift
//  Meet 'n' Eat
//
//  Created by Narcis Zait on 04/11/15.
//  Copyright © 2015 Narcis Zait. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!;
    @IBOutlet weak var emailField: UITextField!;
    @IBOutlet weak var passwordField: UITextField!;
    @IBOutlet weak var profilePhoto: UIImageView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView;
            spinner.startAnimating();
            
            let newUser = PFUser();
            newUser.username = name;
            newUser.email = email;
            newUser.password = password;
            
            //sign up asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                //stop the spinner
                spinner.stopAnimating();
                if ((error) != nil){
                    let alert = UIAlertView(title: "Error", message: "\(error?.localizedDescription)", delegate: self, cancelButtonTitle: "OK");
                    alert.show();
                } else {
                    let alert = UIAlertView(title: "Success", message: "Signed up", delegate: self, cancelButtonTitle: "OK");
                    alert.show();
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home");
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

//
//  ProfileViewController.swift
//  Meet 'n' Eat
//
//  Created by Narcis Zait on 03/11/15.
//  Copyright © 2015 Narcis Zait. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.profilePhoto.clipsToBounds = true;
        self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.width / 2;
        
        
        if let pUserName = PFUser.currentUser()?["username"] as? String {
            self.userNameLabel.text = "@" + pUserName;
        }
        
        let userImageFile = PFUser.currentUser()?["ProfilePic"] as! PFFile
        userImageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
            if (error != nil) {
                let alert = UIAlertView(title: "Error", message: "\(error?.localizedDescription)", delegate: self, cancelButtonTitle: "OK");
                alert.show();
            } else {
                let image = UIImage(data: imageData!);
                self.profilePhoto.image = image;
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    override func viewWillAppear(animated: Bool) {
    //
    //    }
    
    @IBAction func emergencyButton(sender: AnyObject) {
        print("emergency");
    }
    
    
    @IBAction func changePicture(sender: AnyObject) {
        let imagePickerController = UIImagePickerController();
        imagePickerController.delegate = self;
        imagePickerController.sourceType = .PhotoLibrary;
        self.presentViewController(imagePickerController, animated: true, completion: nil);
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        profilePhoto.image = info[UIImagePickerControllerOriginalImage] as? UIImage;

        let imageData: NSData = UIImageJPEGRepresentation(profilePhoto.image!, 50.0)!; // UIImagePNGRepresentation(profilePhoto.image!)!; //
        let imageFile = PFFile(name: "Profile Image.png", data: imageData);
        
        PFUser.currentUser()?.setObject(imageFile!, forKey: "ProfilePic");
        PFUser.currentUser()?.saveInBackground();
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func logOutAction(sender: AnyObject){
        PFUser.logOut();
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login");
            self.presentViewController(viewController, animated: true, completion: nil);
        });
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverSegue" {
            let emergencyViewController = segue.destinationViewController as! EmergencyViewController;
            emergencyViewController.modalPresentationStyle = UIModalPresentationStyle.Popover;
            emergencyViewController.popoverPresentationController!.delegate = self;
            emergencyViewController.popoverPresentationController?.sourceRect = CGRectMake(125
                , 50, 0, 0);
            emergencyViewController.popoverPresentationController?.permittedArrowDirections = [.Up];
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None;
    }
    
}


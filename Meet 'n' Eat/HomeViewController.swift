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

class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
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
                , 30, 0, 0);
            emergencyViewController.popoverPresentationController?.permittedArrowDirections = [.Up];
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None;
    }
    
}

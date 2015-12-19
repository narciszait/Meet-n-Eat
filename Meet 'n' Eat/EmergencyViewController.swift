//
//  EmergencyViewController.swift
//  Meet 'n' Eat
//
//  Created by Narcis Zait on 09/12/15.
//  Copyright © 2015 Narcis Zait. All rights reserved.
//

import UIKit
import Parse

class EmergencyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendNotification(sender: AnyObject) {
        let button = sender as! UIButton
        print(button.titleLabel!.text!);
        
        let notification: PFQuery = PFInstallation.query()!;
        notification.whereKey("deviceType", containedIn: ["ios"]);
        
        PFPush.sendPushMessageToQueryInBackground(notification, withMessage: "Hey! Someone wants to meet here:  \(button.titleLabel!.text!) right now!");
    }

    
}

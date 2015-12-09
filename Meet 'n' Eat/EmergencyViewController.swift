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
        
        PFPush.sendPushMessageToQueryInBackground(notification, withMessage: button.titleLabel!.text!);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

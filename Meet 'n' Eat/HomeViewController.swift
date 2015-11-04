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

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
//        if (PFUser.currentUser() == nil) {
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login");
//                self.presentViewController(viewController, animated: true, completion: nil);
//            })
//        }
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

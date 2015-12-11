//
//  MatchesViewController.swift
//  Meet 'n' Eat
//
//  Created by Narcis Zait on 10/12/15.
//  Copyright © 2015 Narcis Zait. All rights reserved.
//

import UIKit
import Parse

class MatchesViewController: UIViewController  {
    
    
    @IBOutlet weak var matchLabel: UILabel!
    var currentObject: PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.matchLabel.text! = "You have n matches with this user";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

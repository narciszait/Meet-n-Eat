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

class SuccessViewController: UIViewController, PFLogInViewControllerDelegategi {
    
    @IBOutlet weak var facebookName: UILabel!;
    @IBOutlet weak var facebookSex: UILabel!;
    @IBOutlet weak var facebookAge: UILabel!;
    @IBOutlet weak var facebookProfilePicture: UIImageView!;
    
//    var facebookNameString: String = String();
//    var facebookSexString: String = String();
//    var facebookProfilePicImage: UIImage = UIImage();
//    
    
    override func viewDidLoad() {
        super.viewDidLoad();
//        if (FBSDKAccessToken.currentAccessToken() != nil) {
//            let facebookReq = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,gender,picture,age_range"]);
//            facebookReq.startWithCompletionHandler { (connection, result, error: NSError!) -> Void in
//                if (error == nil){
//                    print(result["id"]);
//                    let userID: AnyObject! = result["id"];
//                    self.facebookName.text = result["name"] as! String;
//                    self.facebookSex.text = result["gender"] as! String;
//                    
//                    let avatarLocationURL = NSURL(string: "https://graph.facebook.com/\(userID)/picture?width=1000&height=1000");
//                    print("avatarLocation: \(avatarLocationURL)");
//                    let urlRequest = NSURLRequest(URL: avatarLocationURL!);
//                    
//                    NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
//                        let image = UIImage(data: data!);
//                        self.facebookProfilePicture.image = image!;
//                    })
//                } else {
//                    print("error: \(error)");
//                }
//            }
//        } else {
//            print("no fb token")
//        }

        // Do any additional setup after loading the view.
        let requestParameters = ["fields": "id, email, name, gender"];
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters);
        userDetails.startWithCompletionHandler { (connection, result, error: NSError!) -> Void in
            if (error != nil) {
                print(error.localizedDescription);
                return ;
            } else {
                if (result != nil){
                    let userID: AnyObject! = result["id"];
                    self.facebookName.text = result["name"] as! String;
                    self.facebookSex.text = result["gender"] as! String;
                    
//                    let avatarLocationURL = NSURL(string: "https://graph.facebook.com/\(userID)/picture?width=1000&height=1000");
//                    print("avatarLocation: \(avatarLocationURL)");
//                    let urlRequest = NSURLRequest(URL: avatarLocationURL!);
//                    NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
//                             let image = UIImage(data: data!);
//                             self.facebookProfilePicture.image = image!;
//                    });
                    
                    let myUser: PFUser = PFUser.currentUser()!;
                    myUser.setObject(result["name"], forKey: "Facebook_name");
                    myUser.setObject(result["id"], forKey: "Facebook_id");
                    myUser.setObject(result["gender"], forKey: "Facebook_gender");
                    myUser.setObject(result["email"], forKey: "Facebook_email");

//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        let avatarLocationURL = NSURL(string: "https://graph.facebook.com/\(userID)/picture?width=1000&height=1000");
                        print("avatarLocation: \(avatarLocationURL)");
                        let profilePictureData = NSData(contentsOfURL: avatarLocationURL!);
                        let image = UIImage(data: profilePictureData!);
                        self.facebookProfilePicture.image = image;
                        let profileFileObject = PFFile(data: profilePictureData!);
                        myUser.setObject(profileFileObject!, forKey: "Facebook_profile_picture")
                        myUser.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                            if (error == nil){
                                print("success");
                            } else {
                                print(error!.localizedDescription);
                            }
                        })
//                    }
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
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

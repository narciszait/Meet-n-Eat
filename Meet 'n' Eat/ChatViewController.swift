//
//  ChatViewController.swift
//  Meet 'n' Eat
//
//  Created by Narcis Zait on 10/12/15.
//  Copyright © 2015 Narcis Zait. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var messageTableView: UITableView!;
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageField: UITextField!
    var messagesArray: [String] = [String]();
    var authorsArray: [String] = [String]();
    var model: String?
    @IBOutlet weak var dockViewContraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.messageTableView.delegate = self;
        self.messageTableView.dataSource = self;
        self.messageTableView.separatorStyle = .None;
        
        self.messageField.delegate = self;
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped");
        self.messageTableView.addGestureRecognizer(tapGesture);
        
        self.messageTableView.reloadData()
        self.tableViewScrollToBottom(true)
        self.retrieveMessages();
        
        model = UIDevice.currentDevice().modelName;
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "retrieveMessages", userInfo: nil, repeats: true);
        
        
        
    }
    
//    -(void)viewWillAppear:(BOOL)animated {
//    [self.tableView reloadData];
//    NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    }
    
//    override func viewWillAppear(animated: Bool) {
//        self.messageTableView.reloadData()
//        self.tableViewScrollToBottom(true)
//    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC);
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay));
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.messageTableView.numberOfSections;
            let numberOfRows = self.messageTableView.numberOfRowsInSection(numberOfSections-1);
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.messageTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: animated);
            }
        });
    }
    func tableViewTapped(){
        self.messageField.endEditing(true);
    }
    
    //MARK: TextField methods
    func textFieldDidBeginEditing(textField: UITextField) {
//        if (model == "iPhone 4s") {
//            self.messageTableView.setContentOffset(CGPointMake(0, self.messageTableView.contentSize.height / 2 + 20), animated:true);
//        }
        
         self.tableViewScrollToBottom(true)
        
        self.view.layoutIfNeeded();
        UIView.animateWithDuration(0.5, animations: {
            self.dockViewContraint.constant = 300;
            self.view.layoutIfNeeded();
            }, completion: {(success: Bool) -> Void in
                self.retrieveMessages();
        });

    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.view.layoutIfNeeded();
        UIView.animateWithDuration(0.5, animations: {
            self.dockViewContraint.constant = 40;
            self.view.layoutIfNeeded();
            }, completion: {(success: Bool) -> Void in
                self.retrieveMessages();
        });

    }
    
    //MARK: Send button
    @IBAction func sendAction(sender: AnyObject) {
        self.messageField.endEditing(true);
        self.messageField.enabled = false;
        self.sendButton.enabled = false;
        
        let newMessageObject: PFObject = PFObject(className: "Messages");
        newMessageObject["Text"] = self.messageField.text;
        newMessageObject["Author"] = PFUser.currentUser()!.username;
        
        newMessageObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if (success){
                self.retrieveMessages();
            } else {
                NSLog(error!.description);
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.messageField.enabled = true;
                self.messageField.text = "";
                self.sendButton.enabled = true;
            });
        };
    }
    
    func retrieveMessages() {
        let query: PFQuery = PFQuery(className: "Messages");
        query.orderByDescending("createdAt")
        
        if (model == "iPhone 4s") {
           query.limit = 5;
        }
        if (model == "iPhone 6"){
            query.limit = 12;
        }
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error) -> Void in
            //Clear messagesArray
            self.messagesArray = [String]();
            
            //Loop through the Text & Author Column value of each PFObject
            for object in objects! {
                let messageText: String? = (object as PFObject)["Text"] as? String
                let author: String? = (object as PFObject)["Author"] as? String
                
                //Assign Text to messagesArray and Author to authorArray
                self.messagesArray.append(messageText!);
                if (author == PFUser.currentUser()?.username) {
                    self.authorsArray.append("You");
                } else {
                    
                    self.authorsArray.append(author!);
                }
            }
            
            //Reload tableView
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.messageTableView.reloadData();
                self.tableViewScrollToBottom(true)
                self.messagesArray = self.messagesArray.reverse();
                self.authorsArray = self.authorsArray.reverse();
                dump(self.messagesArray);
            });
        }
    }
    
    //MARK: TableView methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.messageTableView.dequeueReusableCellWithIdentifier("MessageCell")! as! ChatTableViewCell;
        
        if (self.authorsArray[indexPath.row] == "You"){
            cell.author.textAlignment = NSTextAlignment.Right;
            cell.message.textAlignment = NSTextAlignment.Right;
            cell.author.textColor = UIColor(red: 173/255, green: 25/255, blue: 200/255, alpha: 1);
            cell.message.textColor = UIColor(red: 173/255, green: 25/255, blue: 200/255, alpha: 1);
        } else {
            cell.author.textColor = UIColor.blackColor();
            cell.message.textColor = UIColor.blackColor();
            cell.author.textAlignment = NSTextAlignment.Left;
            cell.message.textAlignment = NSTextAlignment.Left;
        }
        cell.message.text = self.messagesArray[indexPath.row];
        cell.author.text = "\(self.authorsArray[indexPath.row]) said";
        
        return cell        
    }
    
    //MARK: Popover from the logo
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

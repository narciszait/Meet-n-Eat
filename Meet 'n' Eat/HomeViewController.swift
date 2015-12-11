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

class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var users = [PFObject]();
    @IBOutlet weak var collectionView: UICollectionView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
//        
//        let cellWidth = ((UIScreen.mainScreen().bounds.width) - 32 - 30) / 3;
//        let cellLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout;
//        cellLayout.itemSize = CGSize(width: cellWidth, height: cellWidth);
        
        self.loadCollectionViewData();
    }
    
    @IBAction func emergencyButton(sender: AnyObject) {
        print("emergency");
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverSegue" {
            let emergencyViewController = segue.destinationViewController as! EmergencyViewController;
            emergencyViewController.modalPresentationStyle = UIModalPresentationStyle.Popover;
            emergencyViewController.popoverPresentationController!.delegate = self;
            emergencyViewController.popoverPresentationController?.sourceRect = CGRectMake(85, 43, 0, 0);
            emergencyViewController.popoverPresentationController?.permittedArrowDirections = [.Up];
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None;
    }
    
    //MARK: fetch users from Parse
    func loadCollectionViewData(){
        let query = PFUser.query();
        query!.whereKey("username", notEqualTo: PFUser.currentUser()!.username!);
        do {
            try users = query!.findObjects()
        } catch {
            print(error)
        }
        
        print("users count: \(users.count)");
//        print(users[0]["username"]);
        
        self.collectionView.reloadData();
    }
    
    //MARK: CollectionView stuff
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell;
        
        if let name = users[indexPath.row]["username"] as? String{
            cell.cellTitle.text = name;
        }

        if let value = users[indexPath.row]["ProfilePic"] as? PFFile {
            let image = users[indexPath.row]["ProfilePic"] as? PFFile
            image!.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    if let imageData = imageData{
                        cell.cellImage.image = UIImage(data: imageData);
                    }
                }
            });
        }
        cell.matchLabel.text = "\(self.checkMatches(indexPath.row))";
        
        cell.cellImage.layer.cornerRadius = cell.cellImage.frame.size.width / 2;
        cell.cellImage.clipsToBounds = true;
        
        
        
        return cell
    }
    
    func checkMatches(index: Int) -> Int{
        var currentUserHobbies: [Int] = PFUser.currentUser()!["Hobbies"] as![Int];
        var serverUserHobbies: [Int] = users[index]["Hobbies"] as! [Int];
        var index = 0;
        
        for i in 0...5 {
            if (currentUserHobbies[i] == serverUserHobbies[i]){
                index++;
            }
        }
        
        print("matches: \(index)");
        return index;
    }
}

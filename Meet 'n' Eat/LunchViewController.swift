//
//  LunchViewController.swift
//  Meet 'n' Eat
//
//  Created by Narcis Zait on 11/12/15.
//  Copyright © 2015 Narcis Zait. All rights reserved.
//

import UIKit
import Parse

class LunchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var users = [PFObject]();
    var hoursString: String?;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
        self.loadCollectionViewData();
        
        self.titleLabel.text = "People having lunch at \(hoursString!)";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: fetch users from Parse
    func loadCollectionViewData(){
        let query = PFUser.query();
        query!.whereKey("username", notEqualTo: PFUser.currentUser()!.username!);
        if (self.hoursString != nil) {
            query!.whereKey("Lunch", equalTo: hoursString!);
        }
//        query!.whereKey("Lunch", equalTo: "11-12");
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

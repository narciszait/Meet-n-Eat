//
//  QuizViewController.swift
//  Meet 'n' Eat
//
//  Created by Narcis Zait on 06/11/15.
//  Copyright © 2015 Narcis Zait. All rights reserved.
//

import UIKit
import Parse

class QuizViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!;
    let headerArray = ["1. What is the perfect Friday/Saturday night for you?", "2. How active are you?", "3. What is enriching you?", "4. Are you recycling your garbage?", "5. Choose your movie soul", "6. What is your secret food personality?"];
    let questionsArray = ["Party, drinks, dancing, music", "Chill at home, Netflix, popcorn", "Café, talk, personal time", "Potato couch", "I might sweat occasionally", "I want to be a superhero!!!", "Books, museums, culture", "Extreme sports, adventure", "Leave me alone….", "110% green", "Of course, when I see the nice cans collector", "One garbage bag – effective", "Disney princess/prince", "Dexter type", "X-man, Ironman…", "Lasagna", "Cakes", "Filet mignon"];
    var dataSource = [String: [String]]();
    var selectedSection = NSMutableArray(capacity: 6);
    var lastIndexPath = NSIndexPath(forRow: 9, inSection: 9);
    
    var container: UIView!;
    var loadingView: UIView!;
    var spinner: UIActivityIndicatorView!;
    
    var reachability: Reachability!;


    override func viewDidLoad() {
        super.viewDidLoad()
//        let firstDictionary = ["data" : headerArray];
//        let secondDictionary = ["data" : questionsArray];
        dataSource = ["header" : headerArray];
        dataSource = ["questions" : questionsArray];
        
        // Do any additional setup after loading the view.
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = UIColor.clearColor();
        
        for i in 0...5{
            selectedSection[i] = 99;
        }
        
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
    }
    
    //MARK: spinner setup
    func showActivityIndicatory(uiView: UIView) {
        //let container: UIView = UIView()
        container = UIView();
        container.frame = uiView.frame;
        container.center = uiView.center;
        container.backgroundColor = UIColor.clearColor();
        container.alpha = 0.3;
        
        //let loadingView: UIView = UIView()
        loadingView = UIView();
        loadingView.frame = CGRectMake(0, 0, 80, 80);
        loadingView.center = uiView.center;
        loadingView.backgroundColor = UIColor.grayColor(); //FromHex(0x444444, alpha: 0.7)
        loadingView.alpha = 0.7;
        loadingView.clipsToBounds = true;
        loadingView.layer.cornerRadius = 10;
        
        //let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        spinner = UIActivityIndicatorView();
        spinner.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge;
        spinner.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
        loadingView.addSubview(spinner);
        container.addSubview(loadingView);
        uiView.addSubview(container);
        spinner.startAnimating();
    }

    
    //MARK: TableView number of sections in the table a.k.a. questions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.headerArray.count;
    }
    
    //MARK: TableView number of rows in a section in the table a.k.a. answers
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return self.headerArray[section]
//    }
    
    //MARK: TableView custom header for each section to fit the text + adding text
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 30));
        headerView.backgroundColor = UIColor.lightGrayColor();
        
        let headerLabel = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, 30));
        headerLabel.text = self.headerArray[section];
        
        headerLabel.numberOfLines = 0;
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.lineBreakMode = .ByWordWrapping;
        headerLabel.textColor = UIColor.blackColor();
        
        if (section == 0) || (section == 3) || (section == 5) {
            headerLabel.font = UIFont(name: "HelveticaNeue", size: 14);
        } else {
            headerLabel.font = UIFont(name: "HelveticaNeue", size: 18);
        }
        
        headerView.addSubview(headerLabel);
        
        return headerView;
    }
    
    //MARK: TableView selecting one answer for each question
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("indexPath0: \(indexPath)");
        print("lastIndex0: \(lastIndexPath)");
        
        let section = indexPath.section
        let oldSection = lastIndexPath.section;
        let row = indexPath.row;
        let oldRow = lastIndexPath.row;
//        let newCell = tableView.cellForRowAtIndexPath(indexPath);
//        let oldCell = tableView.cellForRowAtIndexPath(lastIndexPath);
        
        if (section == oldSection) {
            if (row != oldRow){
                //                newCell?.accessoryType = .Checkmark
                //                oldCell?.accessoryType = .None
                tableView.deselectRowAtIndexPath(lastIndexPath, animated: true);
                selectedSection[indexPath.section] = indexPath.row
                print("selected Section1: \(selectedSection[indexPath.section])");
                lastIndexPath = indexPath;
            }
        } else {
            //            newCell?.accessoryType = .Checkmark;
            selectedSection[indexPath.section] = indexPath.row
            print("selected Section: \(selectedSection[indexPath.section])");
            lastIndexPath = indexPath;
        }
        
        print("indexPath1: \(indexPath)");
        print("lastIndex1: \(lastIndexPath)");
    }

    //MARK: TableView adding the text to each line/question
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "textCell";
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath);
//        cell.textLabel?.text = self.dataSource["questions"]![indexPath.row];
        switch (indexPath.section) {
        case 0:
            cell.textLabel?.text = self.questionsArray[indexPath.row];
        case 1:
            cell.textLabel?.text = self.questionsArray[indexPath.row + 3];
        case 2:
            cell.textLabel?.text = self.questionsArray[indexPath.row + 6];
        case 3:
            cell.textLabel?.text = self.questionsArray[indexPath.row + 9];
        case 4:
            cell.textLabel?.text = self.questionsArray[indexPath.row + 12];
        case 5:
            cell.textLabel?.text = self.questionsArray[indexPath.row + 15];
        default:
            cell.textLabel?.text = ""
        }
        
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .ByWordWrapping
        cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0);
//        cell.thumbnaiImageView.image = UIImage(named: self.imageArray[indexPath.row])
        cell.textLabel?.textColor = UIColor.grayColor();
        
        return cell;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: the continue button
    @IBAction func saveQuiz(sender: AnyObject){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.alpha = 0.75;
            }, completion: { (success) -> Void in
                self.showActivityIndicatory(self.view);
                self.container.alpha = 1.0;
                
                let newUser = PFUser.currentUser()!;
                newUser.setObject(self.selectedSection, forKey: "Hobbies");
                //        newUser.saveInBackground();
                newUser.saveInBackgroundWithBlock { (success, error) -> Void in
                    print("in the save in background");
                    print("\(self.reachability.isReachableViaWiFi()) wifi");
                    
                    self.spinner.stopAnimating();
                    self.container.removeFromSuperview();
                    
                    if ((error) != nil){
                        let alert = UIAlertView(title: "Error", message: "\(error?.localizedDescription)", delegate: self, cancelButtonTitle: "OK");
                        alert.show();
                    } else {
                        let alert = UIAlertView(title: "Success", message: "Signed up", delegate: self, cancelButtonTitle: "OK");
                        alert.show();
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home");
                            self.presentViewController(viewController, animated: true, completion: nil);
                        });
                    }
                }
        });

//        let newUser = PFUser.currentUser()!;
//        newUser.setObject(self.selectedSection, forKey: "Hobbies");
////        newUser.saveInBackground();
//        newUser.saveInBackgroundWithBlock { (success, error) -> Void in
//            print("in the save in background");
//            print("\(self.reachability.isReachableViaWiFi()) wifi");
//            
//            self.spinner.stopAnimating();
//            self.container.removeFromSuperview();
//            
////            self.reachability.whenReachable = { reachability in
////                dispatch_async(dispatch_get_main_queue()) {
////                    if self.reachability.isReachableViaWWAN() {
////                        self.spinner.stopAnimating();
////                        self.container.removeFromSuperview();
////                    }
////                }
////            };
//            
//            if ((error) != nil){
//                let alert = UIAlertView(title: "Error", message: "\(error?.localizedDescription)", delegate: self, cancelButtonTitle: "OK");
//                alert.show();
//            } else {
//                let alert = UIAlertView(title: "Success", message: "Signed up", delegate: self, cancelButtonTitle: "OK");
//                alert.show();
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home");
//                    self.presentViewController(viewController, animated: true, completion: nil);
//                });
//            }
//        }
    }
}

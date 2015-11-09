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
    }
    
    //MARK: TableView stuff
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.headerArray.count;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headerArray[section]
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//    }
    
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
}

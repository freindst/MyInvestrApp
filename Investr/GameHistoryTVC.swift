//
//  GameHistoryTVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 10/14/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class GameHistoryTVC: UIViewController
{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var theGamesTV: UITableView!
    var theGames = [GameRecord]()
    var tempFinal: NSString!
    var theDates = [String]()
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        queryGames()
        if self.revealViewController() != nil
        {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func queryGames()
    {
        let query = PFQuery(className: "Game")
        query.whereKey("Playing", equalTo: false)
        query.whereKey("isFinished", equalTo: true)
        query.whereKey("CurrentPlayers", equalTo:InvestrCore.currUser)
        query.findObjectsInBackgroundWithBlock
        {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if(error == nil)
            {
                if let objects = objects
                {
                    print("Successfully found \(objects.count) games")
                    for i in 0.stride(to: objects.count, by: 1)
                    {
                        var tempPlace = 0
                        for(var j = 0; j < objects[i]["finalStandings"].count; j = j + 1)
                        {
                            
                            if(objects[i].objectForKey("finalStanding")![j].objectForKey("username") as! String == InvestrCore.currUser)
                            {
                                tempPlace = j+1
                                j = 1000000000
                            }
                        }
                        print(tempPlace)
                        let tempID = objects[i].objectId
                        self.theGames.append(GameRecord(name: objects[i]["Name"] as! String, numPlayers: objects[i]["CurrentPlayers"].count, pot: objects[i]["PotSize"] as! Double, end: objects[i]["EndTime"] as! NSDate, gameID: tempID!, place: tempPlace))
                    }
                    self.theGamesTV.reloadData()
                }
            }
            else
            {
                
            }
                
        }
    }
    
    
    
    //UnComment  if we need to manipulate the title of the TV
    
    /*
    func tableView(tableView: UITableView,
    titleForHeaderInSection section: Int) -> String?
    {
    return "Owned Stocks"
    }
    */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.theGames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! GameRecordTVCell
        
        // Configure the cell...
        cell.gameNameLabel.text = theGames[indexPath.row].name
        cell.gamePlaceLabel.text = "Place:\(theGames[indexPath.row].place)"
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        let query2 = PFQuery(className: "Transaction")
        query2.whereKey("userName", equalTo: InvestrCore.currUser)
        query2.whereKey("GameID", equalTo: PFObject(outDataWithClassName: "Game", objectId: theGames[indexPath.row].id))
        query2.findObjectsInBackgroundWithBlock
        {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if(error == nil)
            {
                if let objects = objects
                {
                    self.tempFinal = String(objects[0]["currentMoney"])
                    for i in 0.stride(to: objects[0]["log"].count, by: 1)
                    {
                        //let logString = objects[0]["log"][i]
                        let logString = objects[0].objectForKey("log")![i] as AnyObject
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSxxx"
                        print(logString)
                        let tempTime = logString.objectForKey("time") as! NSDate
                        print(tempTime)
                        
                        if(logString.objectForKey("operation") as! String == "join")
                        {
                            self.theGames[indexPath.row].theTransactions.append(Transaction(type: "Joined the Game", ticker: "", value: "", date: logString.objectForKey("time") as! NSDate, amount: "", wallet: ""))
                        }
                        else if(logString.objectForKey("operation") as! String == "checkout")
                        {
                            self.theGames[indexPath.row].theTransactions.append(Transaction(type: "Game End", ticker: "", value: "", date: logString.objectForKey("time") as! NSDate, amount: "", wallet: ""))
                        }
                        else
                        {
                            let tempValue = logString.objectForKey("value") as! NSNumber
                            let tempAmount = logString.objectForKey("share") as! NSNumber
                            let tempWallet = logString.objectForKey("wallet") as! NSNumber
                            
                            self.theGames[indexPath.row].theTransactions.append(Transaction(type: logString.objectForKey("operation") as! String, ticker: logString.objectForKey("ticker") as! String, value: "\(tempValue)", date: logString.objectForKey("time") as! NSDate, amount: "\(tempAmount)", wallet: "\(tempWallet)"))
                        }
                    }
                    InvestrCore.finalMoney.updateValue("\(self.tempFinal)")
                }
            }
            else
            {
                
            }
        }
        let gameRecordVC = self.storyboard?.instantiateViewControllerWithIdentifier("GameRecordVC") as! GameRecordVC
        gameRecordVC.getInfo(theGames[indexPath.row])
        self.navigationController?.pushViewController(gameRecordVC, animated: true)
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

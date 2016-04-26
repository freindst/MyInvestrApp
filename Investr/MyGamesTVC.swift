//
//  MyGamesTVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/14/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class MyGamesTVC: UIViewController {

    @IBOutlet weak var theGamesTV: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var playingGamesnum = 0
    var playingGames = [String]()
    var newPlayingGames = [Game]()
    var myUpcomingGamesnum = 0
    var myUpcomingGames = [String]()
    var newUpcomingGames = [Game]()
    var endGame = NSDate()
    var tempID = ""
    var tempWallet = 0.0
    var tempStocks = [String]()
    var tempStocksnum = 0
    
    
    func gamesQuery()
    {
        let query2 = PFQuery(className: "Game")       //query of games that are running and the user is in
        query2.whereKey("Playing", equalTo:true)
        query2.whereKey("isFinished", equalTo: false)
        query2.whereKey("CurrentPlayers", equalTo:InvestrCore.currUser)
        query2.findObjectsInBackgroundWithBlock {
            (objects2: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects2!.count) scores.")
                // Do something with the found objects
                if let objects2 = objects2  {
                    self.playingGamesnum = objects2.count
                    for object2 in objects2
                    {
                        self.playingGames.append(object2["Name"]! as! String)
                        self.newPlayingGames.append(Game(name: object2["Name"] as! String, id: object2.objectId!, end: object2["EndTime"] as! NSDate, start: object2["StartTime"] as! NSDate, numPLayers: object2["CurrentPlayers"].count, pot: object2["PotSize"] as! Double, price: object2["Price"] as! Double))
                    }
                }
                self.theGamesTV.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        let query = PFQuery(className: "Game")
        query.whereKey("Playing", equalTo:false)
        query.whereKey("isFinished", equalTo: false)
        query.whereKey("CurrentPlayers", equalTo:InvestrCore.currUser)
        query.findObjectsInBackgroundWithBlock{
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil{
                if let objects = objects
                {
                    self.myUpcomingGamesnum = objects.count
                    for object in objects
                    {
                        self.myUpcomingGames.append(object["Name"]! as! String)
                        self.newUpcomingGames.append(Game(name: object["Name"] as! String, id: object.objectId!, end: object["EndTime"] as! NSDate, start: object["StartTime"] as! NSDate, numPLayers: object["CurrentPlayers"].count, pot: object["PotSize"] as! Double, price: object["Price"] as! Double))
                        
                    }
                    self.theGamesTV.reloadData()
                }
                else
                {
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
        
        
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        gamesQuery()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set up slide menu
        if self.revealViewController() != nil
        {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String?
    {
        if(section == 0)
        {
            return "My Running Games"
        }
        else
        {
            return "My Upcoming Games"
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if(section == 0)
        {
            return newPlayingGames.count
        }
        else
        {
            return newUpcomingGames.count
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell...
        if(indexPath.section == 0)
        {
            cell.textLabel!.text = self.newPlayingGames[indexPath.row].name
        }
        else
        {
            cell.textLabel!.text = self.newUpcomingGames[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
        
        let query4 = PFQuery(className: "Transaction")
        if(indexPath!.section == 0)
        {
        query4.whereKey("GameID", equalTo: PFObject(withoutDataWithClassName: "Game", objectId: self.newPlayingGames[(indexPath?.row)!].id))
        }
        else
        {
          query4.whereKey("GameID", equalTo: PFObject(withoutDataWithClassName: "Game", objectId: self.newUpcomingGames[(indexPath?.row)!].id))
        }
        query4.whereKey("userName", equalTo: InvestrCore.currUser)
        query4.findObjectsInBackgroundWithBlock
            {
                (objects2: [PFObject]?, error: NSError?) -> Void in
                if error == nil
                {
                    if let objects2 = objects2
                    {
                        self.tempWallet = objects2[0]["currentMoney"] as! Double
                        
                        if(indexPath!.section == 0)
                        {
                            let tempNumPlayers = self.newPlayingGames[(indexPath?.row)!].numPlayers
                        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("CurrentGameVC") as! CurrentGameVC
                            viewController.setGame(self.newPlayingGames[(indexPath?.row)!], userWallet: self.tempWallet)
                            viewController.getStocks()
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                        else
                        {
                            print("Hello")
                            let tempNumPlayers = self.newUpcomingGames[(indexPath?.row)!].numPlayers
                            let tempPrice = self.newUpcomingGames[(indexPath?.row)!].price
                            let tempPotSize = self.newUpcomingGames[(indexPath?.row)!].pot
                            let tempStartDate = self.newUpcomingGames[(indexPath?.row)!].start
                            let tempEndDate = self.newUpcomingGames[(indexPath?.row)!].end
                            
                            let plannedViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PlannedGameVC") as! PlannedGameVC
                            plannedViewController.setGameInfo(currentCell.textLabel!.text!, numPlayers: tempNumPlayers, potSize: tempPotSize, price: tempPrice, gameID: self.newUpcomingGames[(indexPath?.row)!].id, start: tempStartDate, end: tempEndDate)
                            self.navigationController?.pushViewController(plannedViewController, animated: true)
                            self.newPlayingGames = []
                            self.newUpcomingGames = []
                        }
                    
                        
                        
                        self.newUpcomingGames = []
                        self.newPlayingGames = []
                    }
                }
                else
                {
                    print("Error: \(error) \(error!.userInfo)")
                }
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

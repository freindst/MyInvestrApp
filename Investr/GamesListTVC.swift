//
//  GamesListTVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/2/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//


import UIKit
import Parse


protocol GamesListTVCDelegate
{
    func VCDidFinish(controller:GamesListTVC)
}

class GamesListTVC: UIViewController
{
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var upcomingGamesTV: UITableView!
    var currentUser = PFUser.currentUser()
    var upcomingGamesnum = 0
    var playingGamesnum = 0
    var upcomingGames = [String]()
    var newUpcomingGames = [Game]()
    var playingGames = [String]()
    var newPlayingGames = [Game]()
    var numPlayers = 0
    var potSize: Double! = 0
    var price = 0.0
    var tempID = ""
    var tempWallet: Double!
    var startDate: NSDate!
    var endDate: NSDate!
    
    
    
    func firstGamesQuery()          //query of games that are not yet running
    {
        let query = PFQuery(className: "Game")
        query.whereKey("Playing", equalTo:false)
        query.whereKey("isFinished", equalTo: false)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects
                {
                    self.upcomingGamesnum = objects.count
                    for object in objects
                    {
                        self.upcomingGames.append(object["Name"]! as! String)
                        self.newUpcomingGames.append(Game(name: object["Name"] as! String, id: object.objectId!, end: object["EndTime"] as! NSDate, start: object["StartTime"] as! NSDate, numPLayers: object["CurrentPlayers"].count, pot: object["PotSize"] as! Double, price: object["Price"] as! Double))
                    }
                    self.upcomingGamesTV.reloadData()
                }
            }
            else
            {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
       
        let query2 = PFQuery(className: "Game")
        query2.whereKey("Playing", equalTo:true)
        query2.whereKey("isFinished", equalTo: false)
        query2.findObjectsInBackgroundWithBlock {
            (objects2: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil{
                if let objects2 = objects2
                {
                    self.playingGamesnum = objects2.count
                    for object2 in objects2
                    {
                        self.playingGames.append(object2["Name"]! as! String)
                        self.newPlayingGames.append(Game(name: object2["Name"] as! String, id: object2.objectId!, end: object2["EndTime"] as! NSDate, start: object2["StartTime"] as! NSDate, numPLayers: object2["CurrentPlayers"].count, pot: object2["PotSize"] as! Double, price: object2["Price"] as! Double))
                    }
                    self.upcomingGamesTV.reloadData()
                }
            }
            else
            {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        firstGamesQuery()  //calls both queries
        self.upcomingGamesTV.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //set up slide menu
        if self.revealViewController() != nil
        {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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
            return "Running Games"
        }
        else
        {
            return "Upcoming Games"
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            cell.textLabel!.text = self.newPlayingGames[indexPath.row].name //display upcoming games
        }
        else
        {
            cell.textLabel!.text = self.newUpcomingGames[indexPath.row].name //display currently running games
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
        let query = PFQuery(className: "Game")
        print(currentCell.textLabel!.text!, terminator: "")
        if(indexPath!.section == 0)
        {
            query.whereKey("objectId", equalTo: self.newPlayingGames[(indexPath?.row)!].id)
        }
        else
        {
            query.whereKey("objectId", equalTo: self.newUpcomingGames[(indexPath?.row)!].id)
        }
        query.findObjectsInBackgroundWithBlock
            {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil
                {
                    //the find succeeded
                    //print("Successfully found \(objects!.count) Games"
                    
                    
                    if let objects = objects
                    {
                        self.tempID = objects[0].objectId!
                        if objects[0]["CurrentPlayers"] != nil
                        {
                            self.numPlayers = objects[0]["CurrentPlayers"]!.count     //setting the number of players label
                        }
                        else
                        {
                            self.numPlayers = 0
                        }
                        
                        if objects[0]["PotSize"] != nil
                        {
                            self.potSize = objects[0]["PotSize"]! as! Double   //setting the potSize label
                        }
                        else
                        {
                            self.potSize = 0
                        }
                        self.price = objects[0]["Price"]! as! Double    //setting the price label
                        self.startDate = objects[0]["StartTime"]! as! NSDate
                        self.endDate = objects[0]["EndTime"]! as! NSDate
                        
                        
                        
                        if(objects[0]["CurrentPlayers"].containsObject(InvestrCore.currUser))
                        {
                            if indexPath!.section == 0
                            {
                                let query2 = PFQuery(className: "Transaction")
                                query2.whereKey("GameID", equalTo: PFObject(withoutDataWithClassName: "Game", objectId: self.newPlayingGames[(indexPath?.row)!].id))
                                query2.whereKey("userName", equalTo: InvestrCore.currUser)
                                query2.findObjectsInBackgroundWithBlock
                                    {
                                        (objects2: [PFObject]?, error: NSError?) -> Void in
                                        if error == nil
                                        {
                                            if let objects2 = objects2
                                            {
                                                self.tempWallet = objects2[0]["currentMoney"] as! Double
                                            }
                                        }
                                        else
                                        {
                                            print("Error: \(error) \(error!.userInfo)")
                                        }
                                        
                                
                                let currentGameVC = self.storyboard?.instantiateViewControllerWithIdentifier("CurrentGameVC") as! CurrentGameVC
                                currentGameVC.setGame(self.newPlayingGames[indexPath!.row], userWallet: self.tempWallet)
                                currentGameVC.getStocks()
                                self.navigationController?.pushViewController(currentGameVC, animated: true)
                                        self.newPlayingGames = []
                                        self.newUpcomingGames = []
                                }
                            }
                            else
                            {
                                let plannedGameVC = self.storyboard?.instantiateViewControllerWithIdentifier("PlannedGameVC") as! PlannedGameVC
                                plannedGameVC.setGameInfo(currentCell.textLabel!.text!, numPlayers: self.numPlayers, potSize: self.potSize, price: self.price, gameID: self.tempID, start: self.startDate, end: self.endDate)
                                plannedGameVC.inGame = true
                                self.navigationController?.pushViewController(plannedGameVC, animated: true)
                                self.newPlayingGames = []
                                self.newUpcomingGames = []
                                
                            }
                        }
                        else
                        {
                            
                            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("PlannedGameVC") as! PlannedGameVC
                            viewController.setGameInfo(currentCell.textLabel!.text!, numPlayers: self.numPlayers, potSize: self.potSize, price: self.price, gameID: self.tempID, start: self.startDate, end: self.endDate)
                            self.navigationController?.pushViewController(viewController, animated: true)
                            self.newPlayingGames = []
                            self.newUpcomingGames = []
                        }
                        
                        
                        
                        
                    }
                }
                else
                {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
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


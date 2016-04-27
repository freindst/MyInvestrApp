//
//  MenuVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/14/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class MenuVC: UIViewController, Observable {

    @IBOutlet weak var gamesTV: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var theGames: NSMutableArray = []
    var thePortfolios: NSMutableArray = []
    var theGamesList: [Game] = []
    var theNames: NSMutableArray = []
    
    
    var currentUser = PFUser.currentUser()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        InvestrCore.alertString.addObserver(self)
        InvestrCore.inPlay(self.theGames, thePorts: self.thePortfolios)
        if self.revealViewController() != nil
        {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // Return the number of sections.
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.theGamesList.count
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MenuGameListTVCell
        
        // Configure the cell...
        let multiplier = pow(10.0, 2)
        let number = self.theNames[indexPath.row] as! Double   //setting the portfolio as a rounded number
        let rounded = round(number * multiplier) / multiplier
        
        cell.nameLabel.text = self.theGamesList[indexPath.row].name
        cell.portLabel.text = "$\(rounded)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! MenuGameListTVCell!
        
        let query = PFQuery(className: "Transaction")
        query.whereKey("userName", equalTo: InvestrCore.currUser)
        query.whereKey("gameName", equalTo: self.theGamesList[indexPath!.row].name)
        query.findObjectsInBackgroundWithBlock
            {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil
                {
                    if let objects = objects
                    {
                        let tempWallet = objects[0]["currentMoney"] as! Double
                        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("CurrentGameVC") as! CurrentGameVC
            
                            viewController.setGame(self.theGamesList[(indexPath?.row)!], userWallet: tempWallet)
                        
                        
                        viewController.getStocks()
                        self.navigationController?.pushViewController(viewController, animated: true)
                        self.theGames = []
                    }
                }
                else
                {
                    print("Error: \(error) \(error!.userInfo)")
                }
        }
        
        
        //NEED GAME GETTER BEFORE THIS CAN BE ACTIVATED
        
    }
    
    func observableStringUpdate(newValue: String, identifier: String)
    {
        let query2 = PFQuery(className: "Game")
        query2.whereKey("Playing", equalTo:true)
        query2.whereKey("isFinished", equalTo:false)
        query2.whereKey("CurrentPlayers", equalTo: InvestrCore.currUser)
        query2.findObjectsInBackgroundWithBlock{
            (objects2: [PFObject]?, error: NSError?) -> Void in
            if(error == nil)
            {
                if let objects2 = objects2
                {
                    for object in objects2
                    {
                        let tempName = object["Name"] as! String
                        let tempID = object.objectId
                        let tempEnd = object["EndTime"] as! NSDate
                        let tempStart = object["StartTime"] as! NSDate
                        let tempNumPlayers = object["CurrentPlayers"].count
                        let tempPot = object["PotSize"] as! Double
                        let tempPrice = object["Price"] as! Double
                       self.theGamesList.append(Game(name: tempName, id: tempID!, end: tempEnd, start: tempStart, numPLayers: tempNumPlayers, pot: tempPot, price: tempPrice))
                        for i in 0.stride(to: self.thePortfolios.count, by: 1)
                        {
                            if(tempID == self.theGames[i] as? NSString)
                            {
                                self.theNames.addObject(self.thePortfolios[i])
                            }
                        }
                        
                    }
                    self.gamesTV.reloadData()
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

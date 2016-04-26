//
//  PlannedGameVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/2/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Parse

class PlannedGameVC: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var potSizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numPlayers: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var enterGameButton: UIButton!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var endDate: UILabel!
    var tempGameName : String!
    var tempNumPlayers : Int!
    var tempPriceLabel : Double!
    var tempPotSize : Double!
    var gameID : String!
    var startTime: String!
    var endTime: String!
    var inGame = false
    
    @IBAction func enterButtonPressed(sender: AnyObject)
    {
        let query = PFQuery(className: "Game")
        query.whereKey("objectId", equalTo: self.gameID)
        query.findObjectsInBackgroundWithBlock
        {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if(error == nil)
            {
                if let objects = objects
                {
                    if(objects[0]["CurrentPlayers"].containsObject(InvestrCore.currUser))
                    {
                        let errorAlertController = UIAlertController(title: "Error", message: "You have already entered this game.", preferredStyle: UIAlertControllerStyle.Alert)
                        errorAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(errorAlertController, animated: true, completion: nil)
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "Confirm", message:
                            "Are your sure to join the game?", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default,handler: {
                            (action: UIAlertAction!) in
                            InvestrCore.joinGame(InvestrCore.userID, gameID: self.gameID)
                            let myGamesTVC = self.storyboard?.instantiateViewControllerWithIdentifier("MyGamesTVC") as! MyGamesTVC
                            self.navigationController?.pushViewController(myGamesTVC, animated: true)
                        }))
                        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
            else
            {
                
            }
        }
        
        
        //needs to add a confirmation button
        //needs to add the function to add to the game
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil
        {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.gameName.text = self.tempGameName
        self.numPlayers.text = "\(self.tempNumPlayers)"
        self.priceLabel.text = "\(self.tempPriceLabel)"
        self.potSizeLabel.text = "\(self.tempPotSize)"
        self.endDate.text = self.endTime
        self.startDate.text = self.startTime
        if(self.inGame == true)
        {
            self.enterGameButton.enabled = false
            self.enterGameButton.setTitle("You Are Already In This Game", forState: .Normal)
        }
        else
        {
            self.enterGameButton.enabled = true
        }
        
        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGameInfo(name: String, numPlayers: Int, potSize: Double, price: Double, gameID: String, start: NSDate, end: NSDate)
    {
        self.title = name
        self.tempNumPlayers = numPlayers
        self.tempPriceLabel = price
        self.tempPotSize = potSize
        self.gameID = gameID
        self.startTime = NSDateFormatter.localizedStringFromDate(start, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        self.endTime = NSDateFormatter.localizedStringFromDate(end, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
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
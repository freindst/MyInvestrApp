//
//  CurrentGameVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/14/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class CurrentGameVC: UIViewController, Observable {

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var walletPortLabel: UILabel!
    @IBOutlet weak var portfolioWorthAIV: UIActivityIndicatorView!
    @IBOutlet weak var currentStocksAIV: UIActivityIndicatorView!
    @IBOutlet weak var portfolioWorthLabel: UILabel!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var hiddenLabel: UILabel!
    @IBOutlet weak var StockTV: UITableView!
    @IBOutlet weak var walletPort: UILabel!
    var tempName : String!
    var stocks: NSMutableArray = []
    var tempEnd = NSDate()
    var tempID : String!
    var tempStock : NSDictionary!
    var transID: String!
    var shortDate: String!
    var timer: NSTimer!
    var refresher: UIRefreshControl!
    var tempVar: Int!
    var walletVal: String!
    var portfolioVal: String!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableSC: UISegmentedControl!
    var names: NSMutableArray = []
    var wallets: NSMutableArray = []
    var walletPortTimer: NSTimer!
    var walletIndicator: Int = 1            //Determines which value is displayed on the top of screen
                                            //1 -> Wallet 2 -> Portfolio

    override func viewDidLoad()
    {
        super.viewDidLoad()
        //sets up slide out menu
        if self.revealViewController() != nil
        {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        InvestrCore.observableString.addObserver(self)
        InvestrCore.currWallet.addObserver(self)
        InvestrCore.transactionID.addObserver(self)
        InvestrCore.alertString.addObserver(self)
        InvestrCore.tempString.addObserver(self)
        InvestrCore.portVal.addObserver(self)
        self.title = tempName
        self.walletPort.text = "$\(InvestrCore.currWallet.value)"
        self.walletVal = "$\(InvestrCore.currWallet.value)"
        self.walletPortLabel.text = "Wallet"
        self.dateLabel.text = "\(self.shortDate)"
        self.refresher = UIRefreshControl()
        self.refresher.addTarget(self, action: "autoRefresh:", forControlEvents: .ValueChanged)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: "autoRefresh", userInfo:  nil, repeats: true)
        self.walletPortTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "walletPortRefresh", userInfo: nil, repeats: true)
        InvestrCore.getStandings(tempID, names: self.names, wallets: self.wallets)
        self.currentStocksAIV.startAnimating()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tableSCChanged(sender: AnyObject)
    {
        self.tempVar = 3
        self.StockTV.reloadData()
    }
    
    
    @IBAction func tempLookupButtonPressed(sender: AnyObject)
    {
        let lookupStockVC = self.storyboard?.instantiateViewControllerWithIdentifier("LookupStockVC") as! LookupStockVC
        lookupStockVC.getInfo(self.tempID)
        self.navigationController?.pushViewController(lookupStockVC, animated: true)
    }
    
    @IBAction func leaderboardButtonPressed(sender: AnyObject)
    {
        let gameStandingsTVC = self.storyboard?.instantiateViewControllerWithIdentifier("GameStandingsTVC") as! GameStandingsTVC
        gameStandingsTVC.getStandings(self.tempID)
        self.navigationController?.pushViewController(gameStandingsTVC, animated: true)
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject)
    {
        autoRefresh()
        InvestrCore.currentGame(InvestrCore.transactionID.value, array: self.stocks)
        self.currentStocksAIV.startAnimating()
        self.tempVar = 2
    }
    
    func autoRefresh()
    {
        self.tempVar = 0
        self.StockTV.reloadData()
        InvestrCore.getPortfolio(InvestrCore.transactionID.value, portfolioLabel: self.hiddenLabel)
    }
    
    func walletPortRefresh()
    {
        if self.walletIndicator == 1                    //The portfolio value is changing to the wallet
        {
            self.walletPortLabel.text = "Wallet"
            self.walletPort.text = self.walletVal
            self.walletIndicator = 2
        }
        else                                            //the wallet value is changing to the portfolio
        {
            self.walletPortLabel.text = "Portfolio Value"
            self.walletPort.text = self.portfolioVal
            self.walletIndicator = 1
        }
    }
    
    @IBAction func historyButtonPressed(sender: AnyObject)
    {
        let currHistoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("CurrHistoryVC") as! CurrHistoryVC
        currHistoryVC.setUp(self.tempID)
        currHistoryVC.navigationController?.title = "Transaction History"
        currHistoryVC.getHistory()
        self.navigationController?.pushViewController(currHistoryVC, animated: true)
    }
    
    func getStocks()
    {
        let query = PFQuery(className: "Transaction")
        query.whereKey("GameID", equalTo: PFObject(withoutDataWithClassName: "Game", objectId: self.tempID))
        query.whereKey("userName", equalTo: InvestrCore.currUser)
        query.findObjectsInBackgroundWithBlock
        {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil
            {
                if let objects = objects
                {
                    
                    if objects[0]["stocksInHand"] != nil
                    {
                        InvestrCore.transactionID.updateValue(objects[0].objectId!)
                    }
                    self.StockTV.reloadData()
                
                }
                else
                {
                    print("Error: \(error) \(error!.userInfo)")
                }
            }
        }
    }
    
    
    
    func observableStringUpdate(newValue: String, identifier: String)
    {
        print("I received \(newValue) for variable: \(identifier)")
        if(identifier == "buyStock")
        {
            let tempVal = newValue.componentsSeparatedByString("-")
            var tempIndex = 0
            var found = false
            for stock in self.stocks
            {
                var i = 0
                if (stock as! Stock).name == tempVal[0]
                {
                    tempIndex = i
                    if InvestrCore.selling == false
                    {
                        (self.stocks.objectAtIndex(tempIndex) as! Stock).value = (self.stocks.objectAtIndex(tempIndex) as! Stock).value + (Int(tempVal[1])!)
                    }
                    else
                    {
                        (self.stocks.objectAtIndex(tempIndex) as! Stock).value = (self.stocks.objectAtIndex(tempIndex) as! Stock).value - (Int(tempVal[1])!)
                        if((self.stocks.objectAtIndex(tempIndex) as! Stock).value == 0)
                        {
                            self.stocks.removeObjectAtIndex(tempIndex)
                        }
                    }
                    self.tempVar = 1
                    
                    found = true
                }
                i++
            }
            if(found == false && InvestrCore.selling == false)
            {
                self.stocks.addObject(Stock(name: tempVal[0], value: (Int(tempVal[1])!), change: 0, buyVal: 0, bidVal: "0"))
                self.tempVar = 1
            }
            self.StockTV.reloadData()
            
        }
        
        
        if(identifier == "transactionID")
        {
            InvestrCore.getPortfolio(newValue, portfolioLabel: self.hiddenLabel)
            InvestrCore.currentGame(newValue, array: self.stocks)
        }
        
        
        if(identifier == "wallet")
        {
            self.walletVal = "$\(newValue)"
        }
        
        if(identifier == "portVal")
        {
            self.portfolioVal = "$\(newValue)"
        }
        
        if(identifier == "alert")
        {
            self.tempVar = 0
            self.StockTV.reloadData()
            self.currentStocksAIV.stopAnimating()
        }
        
        if(identifier == "tempString")
        {
            
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGame(game: Game, userWallet: Double)
    {
        self.tempName = game.name
        self.tempEnd = game.end
        self.shortDate = NSDateFormatter.localizedStringFromDate(self.tempEnd, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        InvestrCore.currWallet.value = "\(userWallet)"
        self.tempID = game.id
        self.navigationController?.navigationItem.backBarButtonItem?.title = self.tempName
    }
    

    
    // MARK: - Navigation

    
    func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String?
    {
        return ""
    }
    
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
        if(self.tableSC.selectedSegmentIndex == 0)
        {
            return self.stocks.count
        }
        else
        {
            return self.names.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var baseCell = UITableViewCell()
        if(self.tableSC.selectedSegmentIndex == 0)
        {
            let cell: StockTVCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StockTVCell
            
            cell.stockNameLabel.text = "\((self.stocks[indexPath.row].name!).uppercaseString)"
            cell.stockNumberLabel.text = "\((self.stocks[indexPath.row] as! Stock).value!) Owned Stocks"
            cell.stockBuyLabel.text = "$\((self.stocks[indexPath.row] as! Stock).buyVal!)"
            cell.stockBidLabel.text = "$\((self.stocks[indexPath.row] as! Stock).bidVal)"
            let tempNum = (self.stocks[indexPath.row] as! Stock).change
            if(tempNum > 0)
            {
                cell.stockChangeLabel.textColor = UIColor.greenColor()
                cell.stockChangeLabel.text = "+\((self.stocks[indexPath.row] as! Stock).change)"
            }
            else if(tempNum < 0)
            {
                cell.stockChangeLabel.textColor = UIColor.redColor()
                cell.stockChangeLabel.text = "\((self.stocks[indexPath.row] as! Stock).change)"
            }
            else
            {
                cell.stockChangeLabel.textColor = UIColor.blackColor()
                cell.stockChangeLabel.text = "\((self.stocks[indexPath.row] as! Stock).change)"
            }
            if(self.tempVar == 2)
            {
                cell.hidden = false
                cell.stockBuyLabel.hidden = true
                cell.stockBidLabel.hidden = true
                cell.stockChangeLabel.hidden = true
                cell.spinner.startAnimating()
                
            }
            else if(self.tempVar == 1)
            {
                cell.hidden = false
                cell.stockBuyLabel.hidden = true
                cell.stockBidLabel.hidden = true
                cell.stockChangeLabel.hidden = true
                cell.spinner.startAnimating()
            }
            else
            {
                cell.hidden = false
                cell.stockBuyLabel.hidden = false
                cell.stockBidLabel.hidden = false
                cell.stockChangeLabel.hidden = false
                cell.spinner.stopAnimating()
            }
            cell.currentBidLabel.hidden = false
            cell.boughtForLabel.hidden = false
            cell.stockNameLabel.hidden = false
            cell.stockNumberLabel.hidden = false
            cell.standingWalletLabel.hidden = true
            cell.standingNumberLabel.hidden = true
            cell.standingNameLabel.hidden = true
            
            baseCell = cell
        }
        else if(self.tableSC.selectedSegmentIndex == 1)
        {
            let cell: StockTVCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath:  indexPath) as! StockTVCell
            
            cell.standingNameLabel.text = "\(self.names[indexPath.row])"
            cell.standingWalletLabel.text = "$\(self.wallets[indexPath.row])"
            cell.standingNumberLabel.text = "\(indexPath.row + 1)"
            cell.standingNameLabel.hidden = false
            cell.standingNumberLabel.hidden = false
            cell.standingWalletLabel.hidden = false
            cell.stockBidLabel.hidden = true
            cell.stockBuyLabel.hidden = true
            cell.stockChangeLabel.hidden = true
            cell.stockNameLabel.hidden = true
            cell.stockNumberLabel.hidden = true
            cell.boughtForLabel.hidden = true
            cell.currentBidLabel.hidden = true
            baseCell = cell
        }
        
        // Configure the cell...
        return baseCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        if(self.tableSC.selectedSegmentIndex == 0)
        {
            let indexPath = tableView.indexPathForSelectedRow
            let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! StockTVCell
            let stockVC = self.storyboard?.instantiateViewControllerWithIdentifier("StockVC") as! StockVC
            let tempNum = (self.stocks[indexPath!.row] as! Stock).value
            stockVC.setUp(currentCell.stockNameLabel.text!, numStocks: tempNum, gameID: self.tempID)
            InvestrCore.getQuote(currentCell.stockNameLabel.text!, label: self.hiddenLabel, value: "Bid")
            InvestrCore.getQuote(currentCell.stockNameLabel.text!, label:self.hiddenLabel, value: "Name")
            self.navigationController?.pushViewController(stockVC, animated: true)
        }
    }
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

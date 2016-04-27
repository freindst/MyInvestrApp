//
//  StockVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/30/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class StockVC: UIViewController, Observable
{

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var numSellingTF: UITextField!
    @IBOutlet weak var payoutLabel: UILabel!
    @IBOutlet weak var totalWorthLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numStocksOwnedLabel: UILabel!
    @IBOutlet weak var currPriceLabel: UILabel!
    
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var sellAllButton: UIButton!
    @IBOutlet weak var spinnerAIV: UIActivityIndicatorView!
    
    var currPrice : Double!
    var numStocksOwned : Int!
    var totalWorth : Double!
    var name : String!
    var payout : Double!
    var ticker: String!
    var gameID: String!
    
    @IBAction func cancelButtonPressed(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func observableStringUpdate(newValue: String, identifier: String)
    {
        print("StockVC: newval: \(newValue) for var: \(identifier)")
        if(identifier == "tempAsk")
        {
            self.currPrice = (Double(newValue)!)
            self.totalWorth = (self.currPrice) * (Double(self.numStocksOwned))
            self.currPriceLabel.text = "Current Price: $\(self.currPrice)"
            
            self.totalWorthLabel.text = "Total Worth $\(self.totalWorth)"
        }
        else if(identifier == "tempName")
        {
            self.name = newValue
            self.nameLabel.text = self.ticker
            self.spinnerAIV.stopAnimating()
            activateLabels()
        }
        
    }
    
    @IBAction func sellButtonPressed(sender: AnyObject)
    {
        InvestrCore.selling = true
        InvestrCore.sellStock((Int(self.numSellingTF.text!)!), ticker: self.ticker)
        InvestrCore.observableString.updateValue ("\(self.ticker)-\(self.numSellingTF.text!)")
        InvestrCore.currWallet.value = (NSString(format:"%.2f", ((Double(InvestrCore.currWallet.value))! + self.payout))) as String
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    
    @IBAction func sellAllButtonPressed(sender: AnyObject)
    {
        InvestrCore.selling = true
        InvestrCore.sellStock(self.numStocksOwned, ticker: self.ticker)
        InvestrCore.observableString.updateValue("\(self.ticker)-\(self.numStocksOwned)")
        InvestrCore.currWallet.value = "\(((Double(InvestrCore.currWallet.value))! + self.totalWorth))"
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func sellValueChanged(sender: UITextField)
    {
        if(sender.text == nil)
        {
            self.sellButton.enabled = false
            self.payoutLabel.text = ""
        }
        else
        {
            self.payout = self.currPrice * (Double(self.numSellingTF.text!)!)
            self.sellButton.enabled = true
            self.payoutLabel.text = "Payout: $\(self.payout)"
        }
    }
    
    func setUp(ticker: String, numStocks: Int, gameID: String)
    {
        self.numStocksOwned = numStocks
        self.ticker = ticker
        self.gameID = gameID
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if self.revealViewController() != nil
        {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.payoutLabel.text = ""
        self.navigationItem.title = ""
        //register as observers
        InvestrCore.tempAsk.addObserver(self)
        InvestrCore.tempName.addObserver(self)
        InvestrCore.checkOwnedStocks(self.numStocksOwnedLabel,tempID: self.gameID, stockName: self.ticker)
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func activateLabels()
    {
        self.numSellingTF.hidden = false
        self.payoutLabel.hidden = false
        self.totalWorthLabel.hidden = false
        self.nameLabel.hidden = false
        self.numStocksOwnedLabel.hidden = false
        self.currPriceLabel.hidden = false
        self.sellButton.hidden = false
        self.sellAllButton.hidden = false
        self.navigationItem.title = self.name
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

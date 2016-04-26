//
//  LookupStockVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 11/11/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class LookupStockVC: UIViewController, UIWebViewDelegate
{
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tickerTF: UITextField!
    @IBOutlet weak var lookupButton: UIButton!
    @IBOutlet weak var stockWV: UIWebView!
    @IBOutlet weak var buyStockButton: UIButton!
    var currURL: String!
    var currTicker: String!
    var tempID: String!
    var wallet: Double!
    
    @IBAction func backButtonPressed(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func buyStockButtonPressed(sender: AnyObject)
    {
        let buyStockVC = self.storyboard?.instantiateViewControllerWithIdentifier("BuyStockVC") as! BuyStockVC
        buyStockVC.getInfo(self.tempID, ticker: self.currTicker)
        self.navigationController?.pushViewController(buyStockVC, animated: true)
    }
    
    
    func getInfo(id: String)
    {
        self.tempID = id
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if self.revealViewController() != nil
        {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let url = NSURL(string: "http://finance.yahoo.com")
        let requestObject = NSURLRequest(URL: url!)
        self.stockWV.loadRequest(requestObject)
        self.stockWV.hidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
        print("Webview fail with error \(error)");
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        return true;
    }
    
    func webViewDidStartLoad(webView: UIWebView)
    {
        print("Webview started Loading")
    }
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        print("Webview did finish load")
        self.currURL = (webView.request?.URL!.absoluteString)!
        //indexes 27 & 28 should equal "s=" if it is a stock page
        if(self.currURL.containsString("s="))
        {
            let index1 = self.currURL.startIndex.advancedBy(29)
            let substring = self.currURL.substringFromIndex(index1)
            let index2 = substring.startIndex.advancedBy(5)
            var tempTickerString = substring.substringToIndex(index2)
            if(tempTickerString.containsString("&"))
            {
                repeat
                {
                    tempTickerString = tempTickerString.substringToIndex(tempTickerString.endIndex.predecessor())
                }
                while(tempTickerString.containsString("&"))
            }
            self.currTicker = tempTickerString
            self.buyStockButton.enabled = true
        }
        print(self.currURL)
        
        if(self.currTicker != nil)
        {
            print(self.currTicker)
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

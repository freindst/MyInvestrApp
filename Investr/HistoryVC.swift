//
//  HistoryVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 10/14/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController
{

    var theTransaction: Transaction!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stocksLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func backButtonPressed(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true);
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
        self.typeLabel.text = "\(self.theTransaction.type.uppercaseString)"
        self.nameLabel.text = "\(self.theTransaction.ticker.uppercaseString)"
        self.stocksLabel.text = "\(self.theTransaction.value)"
        self.moneyLabel.text = "\(self.theTransaction.amount)"
        self.timeLabel.text = "\(self.theTransaction.time)"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getInfo(transaction: Transaction)
    {
        self.theTransaction = transaction
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

//
//  LoginVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/2/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse


class LoginVC: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var username : String!
    var password : String!
    
    @IBAction func submitButtonPressed(sender: AnyObject)
    {
        let username = userNameTF.text!
        let password = passwordTF.text!
        if(self.userNameTF.text != "" && self.passwordTF.text != "")
        {
            PFUser.logInWithUsernameInBackground(username, password: password) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil
                {
                    //success
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(username, forKey: "username")
                    defaults.setObject(password, forKey: "password")
                    defaults.synchronize()
                    
                    let menuVC = self.storyboard?.instantiateViewControllerWithIdentifier("MenuVC") as! MenuVC
                    self.navigationController?.pushViewController(menuVC, animated: true)
                    // Do stuff after successful login.
                    InvestrCore.currUser = self.userNameTF.text!         //saves global username
                    let query = PFUser.query()
                    query!.whereKey("username", equalTo: InvestrCore.currUser)
                    
                    do{
                    _ = try query!.findObjects()
                    }
                    catch
                    {
                        
                    }
                    
                    
                    InvestrCore.userID = PFUser.currentUser()!.objectId!    //saves global user objectId
                    
                }
                else
                {
                    //Error
                    let alert = UIAlertView()
                    alert.title = "Login Error"
                    alert.message = "Invalid Email/Password Combination, Please Try Again"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    // The login failed. Check error to see why.
                }
                
            }
            
            
        }
        else
        {
            let alert = UIAlertView()
            alert.title = "Login Error"
            alert.message = "Invalid Email/Password Combination, Please Try Again"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        let username = defaults.objectForKey("username")
        if(username != nil)
        {
            userNameTF.text = username as? String
            passwordTF.text = defaults.objectForKey("password") as? String
        }
        self.userNameTF.delegate = self
        self.passwordTF.delegate = self
        self.userNameTF.becomeFirstResponder()
        self.username = self.userNameTF.text
        self.password = self.passwordTF.text
        if(self.password != "" && self.username != "")
        {
            PFUser.logInWithUsernameInBackground(self.username, password: self.password) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil
                {
                    //success
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(self.username, forKey: "username")
                    defaults.setObject(self.password, forKey: "password")
                    defaults.synchronize()
                    
                    let menuVC = self.storyboard?.instantiateViewControllerWithIdentifier("MenuVC") as! MenuVC
                    self.navigationController?.pushViewController(menuVC, animated: true)
                    // Do stuff after successful login.
                    InvestrCore.currUser = self.userNameTF.text!         //saves global username
                    let query = PFUser.query()
                    query!.whereKey("username", equalTo: InvestrCore.currUser)
                    
                    do{
                        _ = try query!.findObjects()
                    }
                    catch
                    {
                        
                    }
                    
                    
                    InvestrCore.userID = PFUser.currentUser()!.objectId!    //saves global user objectId
                    
                }
                else
                {
                    //Error
                    let alert = UIAlertView()
                    alert.title = "Login Error"
                    alert.message = "Invalid Email/Password Combination, Please Try Again"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    // The login failed. Check error to see why.
                }
        }
        }

        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func VCDidFinish(controller: GamesListTVC)
    {
        controller.navigationController?.popViewControllerAnimated(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        return true
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    var currentUser = PFUser.currentUser()
    var upcomingGamesnum = 0
    var upcomingGames = [AnyObject]()
    var playingGamesnum = 0
    var playingGames = [AnyObject]()
    
    if(segue.identifier == "gamesListSegue")
    {
    let vc = segue.destinationViewController as! GamesListTVC
    vc.upcomingGamesnum = upcomingGamesnum
    vc.upcomingGames = upcomingGames
    vc.playingGamesnum = playingGamesnum
    vc.playingGames = playingGames
    vc.delegate = self
    }
    }
    */
    
    
}


//
//  MainVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/2/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class MainVC: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    var username: String = ""
    var password: String = ""
    
    @IBAction func loginButtonPressed(sender: AnyObject)        //login button
    {
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    
    @IBAction func registerButtonPressed(sender: AnyObject)     //registration button
    {
        let registerVC = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        if(defaults.objectForKey("username") != nil)
        {
            self.username = defaults.objectForKey("username") as! String
            self.password = defaults.objectForKey("password") as! String
        }
        if(InvestrCore.userID == "")
        {
            if(self.username != "" && self.password != "")
            {
                PFUser.logInWithUsernameInBackground(username, password: password)
                    {
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
                            InvestrCore.currUser = self.username         //saves global username
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
                
                
                // Do any additional setup after loading the view.
            }
        }
        else
        {
            defaults.setObject("", forKey: "username")
            defaults.setObject("", forKey: "password")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


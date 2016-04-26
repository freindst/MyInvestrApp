//
//  RegisterVC.swift
//  Investr
//
//  Created by Timothy Huesmann on 9/2/15.
//  Copyright (c) 2015 Timothy Huesmann. All rights reserved.
//

import UIKit
import Parse

class RegisterVC: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var conPasswordTF: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func loginButtonPressed(sender: AnyObject)
    {
       let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
        self.navigationController?.popToViewController(loginVC, animated: true)
    }
    @IBAction func backButtonPressed(sender: AnyObject)
    {
        let mainVC = self.storyboard?.instantiateViewControllerWithIdentifier("MainVC") as! MainVC
        self.navigationController?.popToViewController(mainVC, animated: true)
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject)
    {
        if(self.usernameTF.text != "" && self.emailTF.text != "" && self.phoneTF.text != "" && self.passwordTF.text != "" && self.conPasswordTF.text != "" && self.passwordTF.text == self.conPasswordTF.text)
        {
            let user = PFUser()
            user.username = self.usernameTF.text
            user.password = self.passwordTF.text
            user.email = self.emailTF.text
            user["phone"] = self.phoneTF.text
            // other fields can be set just like with PFObject
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    _ = error.userInfo["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                } else {
                    // Hooray! Let them use the app now.
                    let alert = UIAlertView()
                    alert.title = "Thank You"
                    alert.message = "You have now registered"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
        }                                       //error checking and responses
        else if(self.usernameTF.text == "")
        {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Please Enter a Username"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        else if(self.emailTF.text == "")
        {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Please Enter an Email"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        else if(self.phoneTF.text == "")
        {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Please Enter a Phone Number"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        else if(self.passwordTF.text == "")
        {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Please Enter a Password"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        else if(self.passwordTF.text != "" && self.passwordTF.text != self.conPasswordTF.text)
        {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Passwords Do Not Match Please Enter Again"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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


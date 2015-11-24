//
//  ViewController.swift
//  Myezteam
//
//  Created by Caflisch, Thomas J. (Tom) on 11/16/15.
//  Copyright (c) 2015 Tom Caflisch. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        email.delegate = self
        password.delegate = self
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        //mealNameLabel.text = textField.text
        // Need to LOGIN here
    }
    
    // MARK: Actions
//    @IBAction func setDefaultLabelText(sender: UIButton) {
//        mealNameLabel.text = "Default Text"
//    }
    
    @IBAction func login(sender: UIButton) {
        
       var user = User(email: self.email.text, password: self.password.text)
        
        // Authenticate the user
        user.authenticate() {
            (token, error) -> Void in

            // If there is an error, display it
            if error != nil {
                var alert = UIAlertController(title: "Error", message: "Unable to login. Please try again", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                // Store the token
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(token, forKey: "myezteamToken")
                
                // Go to events page
                var next = self.storyboard?.instantiateViewControllerWithIdentifier("EventTableViewController") as EventTableViewController
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(next, animated: true, completion: nil)
                }
            }
        }
    }

}


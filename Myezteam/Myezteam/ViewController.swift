//
//  ViewController.swift
//  Myezteam
//
//  Created by Caflisch, Thomas J. (Tom) on 11/16/15.
//  Copyright (c) 2015 Tom Caflisch. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background image
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "loginBackground.png"))
//        let yourImage = UIImage(named: "loginBackground.png")
//        let imageview = UIImageView(image: yourImage)
//        self.view.addSubview(imageview)
        
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

        println("text = " + self.email.text)
        
       var user = User(email: self.email.text, password: self.password.text)
        
        user.authenticate() {
            (data, error) -> Void in
            println("Error = \(error)")
            println("data = \(data)")
        }
    }

    
}

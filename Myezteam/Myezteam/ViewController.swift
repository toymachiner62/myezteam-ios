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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mealNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
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
    
    }

    
}


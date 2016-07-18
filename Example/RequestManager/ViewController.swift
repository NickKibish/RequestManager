//
//  ViewController.swift
//  RequestManager
//
//  Created by Nick Kibish on 07/18/2016.
//  Copyright (c) 2016 Nick Kibish. All rights reserved.
//

import UIKit
import RequestManager

class ViewController: UIViewController {
    @IBOutlet var requestStatulLabel: UILabel!
    @IBOutlet var requestURLTF: UITextField!
    
    @IBAction func makeRequest(sender: AnyObject) {
        requestStatulLabel.text = "Loading..."
        requestStatulLabel.textColor = UIColor.lightGrayColor()
        
        RequestManager.sharedInstance.shouldPrintSuccedResponse = true
        RequestManager.sharedInstance.request(.GET, url: requestURLTF.text!, parameters: nil, success: { (json) in
            self.requestStatulLabel.text = "OK"
            self.requestStatulLabel.textColor = UIColor.greenColor()
            }) { (error) in
                self.requestStatulLabel.text = "Error"
                self.requestStatulLabel.textColor = UIColor.redColor()
        }
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
}
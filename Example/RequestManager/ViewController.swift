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
    @IBOutlet var baseURLTF: UITextField!
    
    @IBAction func makeRequest(sender: AnyObject) {
        requestStatulLabel.text = "Loading..."
        requestStatulLabel.textColor = UIColor.lightGrayColor()
        
        RequestManager.sharedInstance.shouldPrintSuccedResponse = true
        RequestManager.sharedInstance.baseURL = URLString(string: requestURLTF.text!)
        RequestManager.sharedInstance.request(.GET, baseURL: baseURLTF.text!, parameters: nil, success: { (json) in
            self.requestStatulLabel.textColor = UIColor.greenColor()
            self.requestStatulLabel.text = "OK"
        }) { (error) in
            self.requestStatulLabel.textColor = UIColor.redColor()
            self.requestStatulLabel.text = "Error"
        }
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
}
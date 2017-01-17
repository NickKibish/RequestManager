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
    
    @IBAction func makeRequest(_ sender: AnyObject) {
        requestStatulLabel.text = "Loading..."
        requestStatulLabel.textColor = UIColor.lightGray
        
        do {
            let request = try RequestManager.sharedInstance.request(path: requestURLTF.text!, method: .get, parameters: nil)
            RequestManager.sharedInstance.make(request: request, success: { (_, _) in
                self.requestStatulLabel.textColor = UIColor.green
                self.requestStatulLabel.text = "OK"
            }, failure: { (_, _, _) in
                self.requestStatulLabel.textColor = UIColor.red
                self.requestStatulLabel.text = "Error"
            })
        } catch let error as RequestManagerError {
            switch error {
            case .isntReachable:
                Log.error("isn't reachable")
            case .needsConnection:
                Log.error("Needs Connection")
            case .wrongURL:
                Log.error("Wrong URL")
            case .unknownError(_):
                Log.error("Unknown error")
            default:
                Log.error("Other Error")
            }
        } catch {
            Log.error("Error")
        }
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
}

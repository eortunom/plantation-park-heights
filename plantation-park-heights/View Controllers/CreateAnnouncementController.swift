//
//  CreateAnnouncementController.swift
//  plantation-park-heights
//
//  Created by Baker, Abbey on 8/6/19.
//  Copyright © 2019 Ortuno Marroquin, Eduardo. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class CreateAnnouncementController : UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var contentField: UITextField!
    
    @IBAction func didTapSave(_ sender: Any) {
        self.performSegue(withIdentifier: "addNewAnnouncementSegue", sender: self)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveTextToVar() {
        var title: String? = titleField.text
        var content: String? = contentField.text
        
//         prepare json data
        let parameters: [String: AnyObject] = [
            "summary" : title as AnyObject,
            "text" : content as AnyObject
        ]

        Alamofire.request("http://127.0.0.1:5000/add", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if titleField.text == "" || contentField.text == "" {
            let alert = UIAlertController(title: "Alert", message: "No fields can be blank", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        saveTextToVar()
        return true
    }
}

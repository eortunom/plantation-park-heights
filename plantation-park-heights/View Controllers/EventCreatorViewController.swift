//
//  EventCreatorViewController.swift
//  plantation-park-heights
//
//  Created by Ortuno Marroquin, Eduardo on 8/6/19.
//  Copyright © 2019 Ortuno Marroquin, Eduardo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventCreatorViewController: UIViewController {

    @IBOutlet weak var eventNameField: UITextField!
    
    @IBOutlet weak var startDateField: UITextField!
    
    @IBOutlet weak var endDateField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker(field: startDateField)
        showDatePicker(field: endDateField)
        descriptionField.layer.borderWidth = 1
        descriptionField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func showDatePicker(field : UITextField) {
        //Format date selector
        datePicker.datePickerMode = .dateAndTime
        
        //Toolbar for date selector
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let isStart : Bool = field == self.startDateField
        var doneButton : UIBarButtonItem? = nil
        
        doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: isStart ? #selector(setStartDateField) : #selector(setEndDateField));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton, spaceButton, doneButton!], animated: false)
        
        if (isStart) {
            startDateField.inputAccessoryView = toolbar
            startDateField.inputView = datePicker
        } else {
            endDateField.inputAccessoryView = toolbar
            endDateField.inputView = datePicker
        }
    }
    
    @objc func setStartDateField(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy hh:mm a"
        startDateField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func setEndDateField(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy hh:mm a"
        endDateField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveEvent() {
        let parameters: [String: AnyObject] = [
            "name" :  eventNameField.text! as AnyObject,
            "start_date" : startDateField.text! as AnyObject,
            "end_date" : endDateField.text! as AnyObject,
            "description" : descriptionField.text! as AnyObject
        ]
        
        Alamofire.request("http://127.0.0.1:5000/event/add", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    }

    @IBAction func didTapSave(_ sender: Any) {
        self.performSegue(withIdentifier: "addNewEventSegue", sender: self)
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if eventNameField.text == "" || startDateField.text == "" ||
            endDateField.text == "" || descriptionField.text == "" {
            let alert = UIAlertController(title: "Alert", message: "No fields can be blank", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        saveEvent()
        return true
    }

}

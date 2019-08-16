//
//  EventViewControllerTableViewController.swift
//  plantation-park-heights
//
//  Created by Ortuno Marroquin, Eduardo on 8/6/19.
//  Copyright © 2019 Ortuno Marroquin, Eduardo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var events = [Event(nam: "hardcodedEvent", start: "12/1/19", end: "12/2/19", desc: "My event description"),]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
        getEvents()
        if tableView.numberOfRows(inSection: 0) == 0 {
            let messageLabel = UILabel()
            messageLabel.text = "No events yet"
            messageLabel.textColor = UIColor.black
            messageLabel.textAlignment = .center;
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel;
            tableView.separatorStyle = .none;
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getEvents()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if events.count == 0 {
            let messageLabel = UILabel()
            messageLabel.text = "No events yet"
            messageLabel.textColor = UIColor.gray
            messageLabel.textAlignment = .center;
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel;
            tableView.separatorStyle = .singleLine;
        } else {
            tableView.backgroundView = nil;
        }
        return events.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell")
        cell?.textLabel?.text = events[indexPath.row].name
        cell?.detailTextLabel?.text = events[indexPath.row].startDate +
            " to " + events[indexPath.row].endDate
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Event description", message: events[indexPath.row].description, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: {tableView.deselectRow(at: indexPath, animated: true)})
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    // MARK: - Navigation

     @IBAction func addNewEvent(segue: UIStoryboardSegue) {  }
    
    func getEvents() {
        Alamofire.request("http://127.0.0.1:5000/events", method: .get, encoding: JSONEncoding.default).responseJSON { response in
            guard let object = response.result.value else {
                print("Oh, no!!!")
                return
            }
            self.events.removeAll()
            let json = JSON(object)
            if let jArray = json.array {
                for entry in jArray {
                    if let name = entry["EVNT_NAME"].string,
                        let description = entry["EVNT_DESC"].string,
                        let start = entry["EVNT_START_DATE"].string,
                        let end = entry["EVNT_END_DATE"].string{
                        let event : Event = Event(nam: name, start: start, end: end, desc: description)
                        self.events.append(event)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
}

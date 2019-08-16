//
//  ViewAnnouncements.swift
//  plantation-park-heights
//
//  Created by Baker, Abbey on 8/6/19.
//  Copyright © 2019 Ortuno Marroquin, Eduardo. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

struct Announcement {
    var announcementTitle : String
    var annoucementDate : String
    var announcementContent : String
}

class AnnouncementTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var announcements = [Announcement(announcementTitle: "Lorem Ipsum", annoucementDate: "Wed, 03 Aug 2019 12:27:10 GMT", announcementContent: "hi"),]
    
    @IBOutlet var myTableView: UITableView! {
        didSet {
            myTableView.dataSource = self
            myTableView.dataSource = self
            getNotifications()
            myTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if announcements.count == 0 {
            let messageLabel = UILabel()
            messageLabel.text = "No announcements yet"
            messageLabel.textColor = UIColor.gray
            messageLabel.textAlignment = .center;
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel;
            tableView.separatorStyle = .singleLine;
        } else {
            tableView.backgroundView = nil;
        }
        return announcements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "announcementCell", for: indexPath)
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = .byWordWrapping
        cell.textLabel!.font = UIFont.systemFont(ofSize: 14.0)
        
        cell.textLabel?.text = announcements[indexPath.row].annoucementDate + " " + announcements[indexPath.row].announcementTitle + "\n\n" + announcements[indexPath.row].announcementContent
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getNotifications()
    }
    
    @IBAction func addNewAnnouncement(segue: UIStoryboardSegue) {  }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNotifications()
    }
    
    func getNotifications() {
        Alamofire.request("http://127.0.0.1:5000/notifications", method: .get, encoding: JSONEncoding.default).responseJSON { response in
            guard let object = response.result.value else {
                print("Oh, no!!!")
                return
            }
            self.announcements.removeAll()
            let json = JSON(object)
            if let jArray = json.array {
                for entry in jArray {
                    if let title = entry["NTFY_SUMRY"].string,
                        let time = entry["NTFY_SENT_DATE"].string,
                        let content = entry["NTFY_TXT"].string {
                        let announcement : Announcement = Announcement(announcementTitle: title, annoucementDate: time, announcementContent: content)
                        self.announcements.append(announcement)
                    }
                }
            }
            self.myTableView.reloadData()
        }
    }
}

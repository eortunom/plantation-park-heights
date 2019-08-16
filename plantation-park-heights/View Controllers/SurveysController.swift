//
//  SurveysController.swift
//  plantation-park-heights
//
//  Created by Baker, Abbey on 8/7/19.
//  Copyright © 2019 Ortuno Marroquin, Eduardo. All rights reserved.
//

import Foundation
import UIKit

struct Survey {
    var surveyName : String
    var surveyLink : String
}

class SurveysController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // TODO: pull surveys from DB instead of hardcoding
    var surveys = [
        Survey(surveyName: "Survey 1", surveyLink: "https://forms.gle/LTYuNkzCVA1iE2q56"),
        Survey(surveyName: "Survey 2", surveyLink: "https://forms.gle/BRWTZT2JUvhBnKA98"),
        Survey(surveyName: "Survey 3", surveyLink: "https://forms.gle/75vibUBhD62RzVb4A")
    ]
    
    @IBOutlet var myTableView: UITableView! {
        didSet {
            myTableView.delegate = self
            myTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "surveyCell", for: indexPath)
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = .byWordWrapping
        cell.textLabel!.font = UIFont.systemFont(ofSize: 14.0)
        cell.textLabel?.text = surveys[indexPath.row].surveyName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let application = UIApplication.shared
        let webURL = URL(string:surveys[indexPath.row].surveyLink)!
        application.open(webURL)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}

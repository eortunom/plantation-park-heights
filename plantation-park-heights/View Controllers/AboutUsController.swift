//
//  AboutUsController.swift
//  plantation-park-heights
//
//  Created by Baker, Abbey on 8/7/19.
//  Copyright © 2019 Ortuno Marroquin, Eduardo. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class AboutUsController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBAction func scanAction(sender: AnyObject) {
        let Username =  "cleanergreenerfoods" // Your Instagram Username here
        let appURL = URL(string: "instagram://user?username=\(Username)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            let webURL = URL(string: "https://instagram.com/\(Username)")!
            application.open(webURL)
        }
    }
    
    @IBAction func FacebookAction() {
        let Username =  "plantationparkheightsurbanfarm" // Your Facebook Username here
        let appURL = URL(string: "fb://profile/\(Username)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            let webURL = URL(string: "https://facebook.com/\(Username)")!
            application.open(webURL)
        }
    }
    
    @IBAction func startNav(sender: AnyObject) {
        let latitude:CLLocationDegrees = 39.332778
        let longitude:CLLocationDegrees = -76.660678
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapitem = MKMapItem(placemark: placemark)
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapitem.name = "Plantation - Park Heights Urban Farm"
        mapitem.openInMaps(launchOptions: options)
    }
    
    @IBAction func openPhone(sender: AnyObject) {
        guard let number = URL(string: "tel://4432678785") else { return }
        UIApplication.shared.open(number)
    }
}

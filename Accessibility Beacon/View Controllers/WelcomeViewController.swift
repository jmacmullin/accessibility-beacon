//
//  WelcomeViewController.swift
//  Accessibility Beacon
//
//  Created by Jake MacMullin on 12/07/2014.
//  Copyright (c) 2014 Stripy Sock Software. All rights reserved.
//

import UIKit
import CoreLocation

class WelcomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    @IBOutlet var welcomeLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func requestLocationPermission() -> Void {
        var locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        self.locationManager = locationManager
    }
    
    // Location Manager Delegate Methods
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) -> Void {
        manager.stopUpdatingLocation()
        self.performSegueWithIdentifier("ShowInstructions", sender: self)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) -> Void {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) -> Void {
        switch status {
        case CLAuthorizationStatus.Authorized:
            self.performSegueWithIdentifier("ShowInstructions", sender: self)
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setBool(true, forKey: "ready-to-go")
            userDefaults.synchronize()
        case CLAuthorizationStatus.Denied:
            if let label = self.welcomeLabel {
                label.text = "Location Services are required to use this app. Please enable them in the Privacy section of the Settings app."
                UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil)
            }
        default:
            if let label = self.welcomeLabel {
                label.text = "..."
            }
        }
    }
}

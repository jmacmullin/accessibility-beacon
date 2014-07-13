//
//  AppDelegate.swift
//  Accessibility Beacon
//
//  Created by Jake MacMullin on 12/07/2014.
//  Copyright (c) 2014 Stripy Sock Software. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
                            
    var window: UIWindow?
    var locationManager: CLLocationManager?

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        
        var firstRun = !NSUserDefaults.standardUserDefaults().boolForKey("ready-to-go")
        
        // if this isn't the first run then monitor for beacons
        if !firstRun {
            self.registerForBeaconRegions()
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName("LETSGO", object: nil, queue: NSOperationQueue.mainQueue()) {
            _ in
            self.registerForBeaconRegions()
        }
        
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication!) {

        if let rootController = self.window?.rootViewController as? RootViewController {
            var locationInfo = LocationInfo()
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if let name = userDefaults.valueForKey("location-name") as? String {
                locationInfo.name = name
            }
            if let address = userDefaults.valueForKey("location-address") as? String {
                locationInfo.address = address
            }
            if let description = userDefaults.valueForKey("location-description") as? String {
                locationInfo.accessibilityDescription = description
            }
            
            rootController.currentLocation = locationInfo
        }

        
    }
    
    func registerForBeaconRegions() -> Void {
        self.locationManager = CLLocationManager()
        if let locationManager = self.locationManager {
            locationManager.delegate = self
            
            let uuid = NSUUID(UUIDString: "753C34CD-EDBF-4F47-A91F-559DA292BBDD")
            let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "au.com.stripysock.accessiblebeacon")
            locationManager.startMonitoringForRegion(beaconRegion)
        }
    }

    func presentNotification(beacon: CLBeacon) -> Void {
        
        let notification = UILocalNotification()
        
        // look up the details of the location based on the beacon's minor identifier
        if let identifier = beacon.minor? {
            
            let serviceClient = CentrelinkServiceClient()
            serviceClient.getLocationInfo(identifier.integerValue) {
                (var locationInfo) in
                
                // save the location info to user defaults so we can get it easily when 
                // the app is next launched
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setValue(locationInfo.name, forKey: "location-name")
                userDefaults.setValue(locationInfo.address, forKey: "location-address")
                userDefaults.setValue(locationInfo.accessibilityDescription, forKey: "location-description")
                userDefaults.synchronize()
                
                notification.alertBody = "You have arrived at \(locationInfo.name)"
                UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            }
            
        }
    }
    
    // CLLocationManager Delegate Methods
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) -> Void {
        println("Entered Region")
        
        var beaconRegion = region as CLBeaconRegion
        manager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) -> Void {
        var beaconRegion = region as CLBeaconRegion
        manager.stopRangingBeaconsInRegion(beaconRegion)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue("", forKey: "location-name")
        userDefaults.setValue("", forKey: "location-address")
        userDefaults.setValue("", forKey: "location-description")
        userDefaults.synchronize()
        println("Exited Region")
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {

        // TODO: expand this to work with more than one beacon per location
        if let beacon = beacons[0] as? CLBeacon {
            self.presentNotification(beacon)
        }
        
        manager.stopRangingBeaconsInRegion(region)
        
    }
}


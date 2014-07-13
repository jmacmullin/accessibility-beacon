//
//  RootViewController.swift
//  Accessibility Beacon
//
//  Created by Jake MacMullin on 12/07/2014.
//  Copyright (c) 2014 Stripy Sock Software. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet var onboardingContainerView: UIView?
    @IBOutlet var locationDetailContainerView: UIView?
    
    var locationDetailViewController: LocationDetailViewController?
    
    var currentLocation: LocationInfo? = nil {
        didSet {
            if let locationViewController = self.locationDetailViewController {
                locationViewController.currentLocation = self.currentLocation
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserverForName("LETSGO", object: nil, queue: NSOperationQueue.mainQueue()) {
            _ in
            self.hideOnBoardingIfNotFirstRun()
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.hideOnBoardingIfNotFirstRun()
    }
    
    func hideOnBoardingIfNotFirstRun() -> Void {
        var firstRun = !NSUserDefaults.standardUserDefaults().boolForKey("ready-to-go")
        
        // if this isn't the first run hide the on-boarding container view & show the location detail container view
        if !firstRun {
            if let onboardingView = self.onboardingContainerView {
                onboardingView.hidden = true
            }
            if let locationView = self.locationDetailContainerView {
                locationView.hidden = false
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if let identifier = segue.identifier {
            if (segue.identifier == "EmbedLocationDetail") {
                self.locationDetailViewController = segue.destinationViewController as? LocationDetailViewController
            }
        }
    }
}

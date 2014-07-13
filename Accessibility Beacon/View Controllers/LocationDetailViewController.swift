//
//  LocationDetailViewController.swift
//  Accessibility Beacon
//
//  Created by Jake MacMullin on 12/07/2014.
//  Copyright (c) 2014 Stripy Sock Software. All rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var addressLabel: UILabel?
    @IBOutlet var descriptionLabel: UILabel?

    var currentLocation: LocationInfo? = nil {
        didSet {
            if let nameLabel = self.nameLabel {
                nameLabel.text = self.currentLocation?.name
            }
            if let addressLabel = self.addressLabel {
                addressLabel.text = self.currentLocation?.address
            }
            if let descriptionLabel = self.descriptionLabel {
                descriptionLabel.text = self.currentLocation?.accessibilityDescription
            }
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

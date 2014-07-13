//
//  InstructionsViewController.swift
//  Accessibility Beacon
//
//  Created by Jake MacMullin on 12/07/2014.
//  Copyright (c) 2014 Stripy Sock Software. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func gotIt() -> Void {
        // do something to cause the root view controller to hide the onboarding
        NSNotificationCenter.defaultCenter().postNotificationName("LETSGO", object: nil)
    }
}

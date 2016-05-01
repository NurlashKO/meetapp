//
//  ViewController.swift
//  meetapp
//
//  Created by Nurlan on 26/04/2016.
//  Copyright © 2016 Nurlan. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    var items = [UserObject]()

    func addDummyData() {
        RestApiManager.sharedInstance.getUserData { (json: JSON) in
            if let results = json[0]["UserGuidId"].array {
                for entry in results {
                    self.items.append(UserObject(json: entry["user"]))
                }
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        addDummyData()
    }
}


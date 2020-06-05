//
//  ViewController.swift
//  UserLocation
//
//  Created by Kenny on 6/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class MapSelectionView: UIViewController {
    let mapController = MapController()
    let segueID = "ShowMap"

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func viewMapButtonPressed(_ sender: Any) {
        //TODO: Error handling
        mapController.checkPermissionAndShowMapView { _ in
            self.performSegue(
                withIdentifier: segueID,
                sender: nil
            )
        }
    }

}


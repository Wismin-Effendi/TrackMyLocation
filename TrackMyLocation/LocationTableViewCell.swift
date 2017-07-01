//
//  LocationTableViewCell.swift
//  TrackMyLocation
//
//  Created by Wismin Effendi on 6/30/17.
//  Copyright © 2017 iShinobi. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var latitudeLongitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    var location: Location? {
        didSet { updateUI() }
    }

    private func updateUI() {
        dateTimeLabel?.text = location?.dateTimeString
        latitudeLongitudeLabel?.text = location?.latLonCoordinate
        addressLabel?.text = location?.address
    }

}

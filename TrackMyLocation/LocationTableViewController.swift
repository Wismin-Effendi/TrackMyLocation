//
//  LocationTableViewController.swift
//  TrackMyLocation
//
//  Created by Wismin Effendi on 6/30/17.
//  Copyright © 2017 iShinobi. All rights reserved.
//

import UIKit
import CoreLocation

class LocationTableViewController: UITableViewController {

    @IBOutlet weak var clearAllButton: UIBarButtonItem!
    @IBOutlet weak var getLocationButton: UIBarButtonItem!
    
    fileprivate var locations = [Location]()
    
    let locationManager = CLLocationManager()
    
    var lastLocationUpdateTime: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        clearAllButton.isEnabled = !locations.isEmpty
        getLocationButton.isEnabled = true 
    }


    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func getLocationTapped(_ sender: UIBarButtonItem) {
        locationManager.startUpdatingLocation()
        getLocationButton.isEnabled = false
    }
    
    @IBAction func clearAllTapped(_ sender: UIBarButtonItem) {
        locationManager.stopUpdatingLocation()
        locations.removeAll()
        tableView.reloadData()
        // just delete all location, nothing else to clear
        clearAllButton.isEnabled = false
        getLocationButton.isEnabled = true
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)

        let location = locations[indexPath.row]
        if let locationCell = cell as? LocationTableViewCell {
            locationCell.location = location
        }

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            locations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

}

// MARK: CLLocationManagerDelegate
extension LocationTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: " + error.localizedDescription)
        getLocationButton.isEnabled = true  // we could get new location now
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        CLGeocoder().reverseGeocodeLocation(manager.location!) { [weak self] (placemarks, error) in
            if error != nil {
                print("Error: " + error!.localizedDescription)
                return
            }
            if placemarks!.count > 0 {
                let placemark = placemarks![0] as CLPlacemark
                self?.locationManager.stopUpdatingLocation()
                
                guard let managerLocation = manager.location else {
                    print("How manager location is nil ??")
                    self?.getLocationButton.isEnabled = true
                    return
                }
                
                let location = Location(coordinate: managerLocation.coordinate, placemark: placemark)
                
                // to avoid updating the table with multiple location updates at once. (same coord and time)
                if self?.lastLocationUpdateTime == nil || ((self?.lastLocationUpdateTime)! < Date().addingTimeInterval(-1.0)) {
                    self?.locations.insert(location, at: 0)
                    self?.tableView.insertRows(at: [IndexPath(row:0, section:0)], with: .fade)
                }
                
                // defer always run before exiting this block (including the guard else above)
                defer {
                    self?.lastLocationUpdateTime = Date()
                    self?.clearAllButton.isEnabled = true  // we have at least one location
                    self?.getLocationButton.isEnabled = true  // we could start a new location now
                }
            }
        }
    }

    
    
}

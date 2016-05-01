//
//  MapVC.swift
//  meetapp
//
//  Created by Nurlan on 26/04/2016.
//  Copyright © 2016 Nurlan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON

class MapVC : UIViewController, CLLocationManagerDelegate,
        UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mapView: UIWebView!

    @IBOutlet weak var eventList: UITableView!

    var locationManager = CLLocationManager()
    var page: String = ""
    var userPosition: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var events: [EventObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            print("CONNECTED...\n")
        }
        self.eventList.delegate = self
        self.eventList.dataSource = self
    }

    func buildRequest(type: String) -> String {
        return "/\(type)?x=\(userPosition.latitude)&y=\(userPosition.longitude)&userId=\(0)"
    }

    func onCompletionMap(json: JSON) -> Void {
        self.page = json.stringValue
        print(self.page)
        self.mapView.loadHTMLString(page, baseURL: nil)
    }

    func onCompletionEventList(json: JSON) -> Void {
        self.events = json.array!.map {EventObject(json: $0)};
        print(self.events.count)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            //reload your tableView
            self.eventList.reloadData()
        })
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

            let cell = eventList.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            let row = indexPath.row
            cell.textLabel?.text = self.events[row].eventName
            cell.detailTextLabel?.text = self.events[row].description

            return cell
    }

    func getView(data: String) {
        print(data)
        RestApiManager.sharedInstance.getViewData(data, onCompletion: onCompletionMap)
    }

    func getEventList(data: String) {
        RestApiManager.sharedInstance.getEventList(data, onCompletion: onCompletionEventList)
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        userPosition = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        getView(buildRequest("ShowMyPosition"))
        //getView(buildRequest("ShowAllUsers"))
        getEventList(buildRequest("ShowAllEvents"))
        locationManager.stopUpdatingLocation()
    }

}

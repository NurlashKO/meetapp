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

class MapVC : UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: UIWebView!

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
            //locationManager.startUpdatingLocation()
            print("CONNECTED...\n")
            //let localfilePath = NSBundle.mainBundle().URLForResource("test", withExtension: "html");
            //let myRequest = NSURLRequest(URL: localfilePath!)
            //mapView.loadRequest(myRequest)
            //mapView.loadHTMLString(page, baseURL: nil)
        }

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
        for e in self.events {
            print(e.eventName)
        }
    }

    func getView(data: String) {
        RestApiManager.sharedInstance.getViewData(data, onCompletion: onCompletionMap)
    }

    func getEventList(data: String) {
        RestApiManager.sharedInstance.getEventList(data, onCompletion: onCompletionEventList)
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        userPosition = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        getView(buildRequest("ShowEventMap"))
        getEventList(buildRequest("ShowAllEvents"))
        locationManager.stopUpdatingLocation()
    }

}

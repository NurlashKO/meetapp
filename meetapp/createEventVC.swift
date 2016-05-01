//
//  createEventVC.swift
//  meetapp
//
//  Created by Nurlan on 01/05/2016.
//  Copyright © 2016 Nurlan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON

class createEventVC: UIViewController, CLLocationManagerDelegate  {


    @IBOutlet weak var mapView: UIWebView!
    var locationManager = CLLocationManager()
    var page: String = ""
    var userPosition: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

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
    }

    func buildRequest() -> String {
        return "?x=\(userPosition.latitude)&y=\(userPosition.longitude)&userId=\(0)"
    }

    func onCompletionCreate(json: JSON) -> Void {
        self.page = json.stringValue
        print(self.page)
        self.mapView.loadHTMLString(page, baseURL: nil)
    }

    func getView(data: String) {
        let path = "http://aspnetwebapiintroductionpublish.azurewebsites.net/htmlrazor"+data
        let url = NSURL (string: path);
        let requestObj = NSURLRequest(URL: url!);
        mapView.loadRequest(requestObj);
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        userPosition = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        getView(buildRequest())
        locationManager.stopUpdatingLocation()
    }
    @IBAction func createEventClick(sender: UIButton) {
        var html = mapView.stringByEvaluatingJavaScriptFromString("document.body.innerHTML")

        if let page = html {
        //    UIWebView.stringByEvaluatingJavaScriptFromString("document.getElementById('myId').value")
        }

    }
}

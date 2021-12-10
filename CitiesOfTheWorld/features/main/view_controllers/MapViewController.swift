//
//  MapViewController.swift
//  CitiesOfTheWorld
//
//  Created by Tareq on 10/12/21.
//

import UIKit
import GoogleMaps
import RealmSwift
class MapViewController: UIViewController {
    // Open the default realm.
    var cities : Results<CityDto>?
    private var itemsToken: NotificationToken?
    let realm = try! Realm()
    override  func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cities = MainViewController.cities
        
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: cities?.first?.lat ?? 34.5166667, longitude: cities?.first?.lon ?? 69.18333440000001, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        
        
        
        cities?.forEach({ cityDto in
            let lat  = cityDto.lat
            let long  = cityDto.lon
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let marker = GMSMarker()
            //marker.icon = UIImage(named: "one.png")
            marker.position = coordinate
            marker.title = cityDto.cityName as? String
            marker.snippet = cityDto.countryName as? String
            marker.appearAnimation = .pop
            marker.map = mapView        })
        
        
    }
    
    
    
    func updateMarker(){
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: cities?.first?.lat ?? 34.5166667, longitude: cities?.first?.lon ?? 69.18333440000001, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        
        
        
        cities?.forEach({ cityDto in
            let lat  = cityDto.lat
            let long  = cityDto.lon
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let marker = GMSMarker()
            //marker.icon = UIImage(named: "one.png")
            marker.position = coordinate
            marker.title = cityDto.cityName as? String
            marker.snippet = cityDto.countryName as? String
            marker.appearAnimation = .pop
            marker.map = mapView        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        itemsToken?.invalidate()
    }
    
}

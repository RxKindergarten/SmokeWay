//
//  MainVC.swift
//  SmokeWay
//
//  Created by 이주혁 on 2021/03/22.
//

import UIKit
import Firebase
import NMapsMap
import CoreLocation
import SnapKit

class MainVC: UIViewController,CLLocationManagerDelegate {
    
    let mapView = NMFMapView()
    
    var latitude: Double?  {
        didSet{
            print("kkk")
            print(latitude)
            
        }
    }
    var longitude: Double?  {
        didSet{
            print("kkk")
            print(longitude)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMapView()
        
        
        //        moveToCurrent()
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        let coor = locationManager.location?.coordinate
        latitude = coor?.latitude
        longitude = coor?.longitude
   
        
    }
    
    
    
    
    
    func setMapView(){
        
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
            
        }
        
        let locationOverlay = mapView.locationOverlay
        locationOverlay.hidden = false
        locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        
        mapView.positionMode = .direction
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.5666102, lng: 126.9783881))
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: 37.5670135, lng: 126.9783740)
        marker.mapView = mapView
        
        let infoWindow = NMFInfoWindow()
        infoWindow.open(with: marker)
        
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 3
        
        
        mapView.moveCamera(cameraUpdate)
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("callll")
        if let coor = manager.location?.coordinate {
            latitude = coor.latitude
            longitude = coor.longitude
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: Double(coor.latitude), lng: Double(coor.longitude)))
            cameraUpdate.animation = .fly
            cameraUpdate.animationDuration = 3
            mapView.moveCamera(cameraUpdate)
            
        }
    }
    
    
    
}

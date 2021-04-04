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

class MainVC: UIViewController {
    
    let mapView = NMFMapView()
    let locationManager = CLLocationManager()
    var currentPoint: MapPoint? {
        didSet{
            let locationOverlay = mapView.locationOverlay
            locationOverlay.location = NMGLatLng(lat: currentPoint?.latitude ?? 0.0, lng: currentPoint?.longitude ?? 0.0)
            moveToPoint(latitude: currentPoint?.latitude ?? 0.0, longitude: currentPoint?.longitude ?? 0.0)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMapView()
        
        
     
    }
    
    
    func moveToPoint(latitude: Double, longitude: Double){
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 3
        mapView.moveCamera(cameraUpdate)
    }
    
    
    func setMapView(){
        
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
//        LocationManager Setting
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
  
        

        
//        현재위치 Overlay
        let locationOverlay = mapView.locationOverlay
        locationOverlay.hidden = false
        locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
//        locationOverlay.circleRadius = 50
//        let nmfOverlayImage = NMFOverlayImage(image: UIImage(systemName: "arrow.up")!)
//        locationOverlay.icon = nmfOverlayImage
        
        locationOverlay.subIcon = NMFOverlayImage(image: UIImage(systemName: "arrow.up")!)
        locationOverlay.subIconWidth = 20
        locationOverlay.subIconHeight = 40
        locationOverlay.subAnchor = CGPoint(x: 0.5, y: 1)
        
//        마커 설정하는 법
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: 37.5670135, lng: 126.9783740)
        marker.mapView = mapView
        
        let infoWindow = NMFInfoWindow()
        infoWindow.open(with: marker)
        
    }
    
    
    
}

extension MainVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        if let coor = manager.location?.coordinate {
            currentPoint = MapPoint(latitude: coor.latitude, longitude: coor.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        if status == .authorizedAlways {
            print("authorizedAlways")
        }
    }
    
    
}

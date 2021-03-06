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
import RxSwift
import RxCocoa

import RxSwift
import RxCocoa
import RxGesture

class MainVC: UIViewController {
    
    // MARK:- UI Components
    let mapView = NMFMapView()
    var placeListContainerView: SmokingPlaceListContainerView = {
        let view = SmokingPlaceListContainerView(frame: .zero)
        return view
    }()
    var placeListContainerViewTopConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    // MARK:- Fields
    let locationManager = CLLocationManager()
    let ready = BehaviorRelay(value: true)
    let currentPointRelay = BehaviorRelay(value: MapPoint(latitude: 0.0, longitude: 0.0))
    var mainViewModel = MainViewModel()
    var disposeBag = DisposeBag()
    var currentPoint: MapPoint? {
        didSet{
            let locationOverlay = mapView.locationOverlay
            locationOverlay.location = NMGLatLng(lat: currentPoint?.latitude ?? 0.0, lng: currentPoint?.longitude ?? 0.0)
            moveToPoint(latitude: currentPoint?.latitude ?? 0.0, longitude: currentPoint?.longitude ?? 0.0)
            currentPointRelay.accept(currentPoint!)
            print(currentPoint)
        }
    }
    
    private var input: MainViewModel.Input!
    private var output: MainViewModel.Output!
    
    let infoWindow = NMapsMap.NMFInfoWindow()

    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setMapView()
        initLayout()
        bindViewModel()
     
    }
    
    private func bindViewModel() {
        input = MainViewModel.Input(ready: ready.asDriver() ,
                                    currentPoint: currentPointRelay.asObservable(),
                                    selectedPoint: Driver.just(MapPoint(latitude: 0, longitude: 0)),
                                    swipeViewGesture: placeListContainerView.asPanGestureDriver(),
                                    itemSelectEvent: placeListContainerView.asItemSelectDriver())
        output = mainViewModel.transform(input: input)
        
        print("bindViewModel")
        let handler = { [weak self] (overlay: NMFOverlay) -> Bool in
            if let marker = overlay as? NMFMarker {
                if marker.infoWindow == nil {
                    // 현재 마커에 정보 창이 열려있지 않을 경우 엶
                    self?.infoWindow.open(with: marker)
                } else {
                    // 이미 현재 마커에 정보 창이 열려있을 경우 닫음
                    self?.infoWindow.close()
                }
            }
            return true
        };
        print(output.surroundInfos)
        output.surroundInfos.drive(onNext: { infoList in
            let handler = { [weak self] (overlay: NMFOverlay) -> Bool in
                if let marker = overlay as? NMFMarker {
                    
//                    여기에 marker handler 추가 필요
                    
                    
//                    if marker.infoWindow == nil {
//                        // 현재 마커에 정보 창이 열려있지 않을 경우 엶
//                        self?.infoWindow.open(with: marker)
//                    } else {
//                        // 이미 현재 마커에 정보 창이 열려있을 경우 닫음
//                        self?.infoWindow.close()
//                        print("cal2")
//                    }
                }
                return true
            }
            
            
            for info in infoList {
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: info.mapPoint.latitude, lng: info.mapPoint.longitude)
                marker.mapView = self.mapView
                marker.touchHandler = handler
                print("here")
                
            }
        }, onCompleted: {
            
        }, onDisposed: {
            
        })
        
        // Expansion
        bindPlaceListContainerView(output.exapansion, output.selectEvent)
        
        // Select
        placeListContainerView
            .bindPlaceListViewData(output.sortedInfos)
            .disposed(by: disposeBag)
        
        presentDetailView(output.detailInfo)
    }
    
    private func initLayout() {
        view.addSubview(placeListContainerView)
        
        placeListContainerViewTopConstraint = placeListContainerView
            .topAnchor
            .constraint(equalTo: view.topAnchor,
                        constant: view.frame.height - placeListContainerView.SWIPEVIEW_HEIGHT + view.safeAreaInsets.bottom)
        placeListContainerViewTopConstraint.isActive = true

        NSLayoutConstraint.activate([
            placeListContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeListContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeListContainerView.heightAnchor.constraint(equalToConstant: view.frame.height * 5 / 6)
        ])
        
    }
    
    private func bindPlaceListContainerView(_ expansion: Driver<Expansion>, _ selectEvent: Driver<Bool>) {
        // SwipeGesture
        expansion.drive(onNext: { [weak self] expansion in
            guard let strongSelf = self else {
                return
            }
            
            switch expansion {
            case .high:
                strongSelf.movePlaceListContainerViewHigh()
            case .low:
                strongSelf.movePlaceListContainerViewLow()
            case .move(let distance):
                strongSelf.movePlaceListContainerDistance(constant: distance)
            }
            
            UIView.animate(withDuration: 0.2) {
                strongSelf.view.layoutIfNeeded()
            }
        }).disposed(by: disposeBag)
        
        // Select
        selectEvent.drive(onNext: { [weak self] isSelected in
            if isSelected {
                self?.movePlaceListContainerViewMiddle()
            }
        }).disposed(by: disposeBag)
    }
    
    private func presentDetailView(_ detailInfo: Driver<SmokingPlace>) {
        detailInfo.drive(onNext: { [weak self] smokingPlace in
            guard let detailVC = DetailVC.instantiateDetailVC(selectedPlace: smokingPlace) else {
                return
            }
            self?.show(detailVC, sender: nil)
        }).disposed(by: disposeBag)
        
    }
    
    private func movePlaceListContainerViewLow() {
        placeListContainerViewTopConstraint.constant = view.frame.height - placeListContainerView.SWIPEVIEW_HEIGHT
    }
    
    private func movePlaceListContainerViewHigh() {
        placeListContainerViewTopConstraint.constant = view.frame.height / 6
    }
    
    private func movePlaceListContainerViewMiddle() {
        placeListContainerViewTopConstraint.constant = view.frame.height - placeListContainerView.CELL_HEIGHT - placeListContainerView.SWIPEVIEW_HEIGHT
    }
    
    private func movePlaceListContainerDistance(constant: CGFloat) {
        var changedPosition = placeListContainerViewTopConstraint.constant + constant
        if changedPosition < view.frame.height / 6 {
            changedPosition = placeListContainerViewTopConstraint.constant
        }
        placeListContainerViewTopConstraint.constant = changedPosition
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



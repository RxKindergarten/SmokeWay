//
//  AddVC.swift
//  SmokeWay
//
//  Created by Yunjae Kim on 2021/05/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NMapsMap
import CoreLocation


class AddVC: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var explainTextView: UITextView!
    @IBOutlet weak var mapContainView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    
    
    let mapView = NMFMapView()
    var disposeBag = DisposeBag()
    let locationManager = CLLocationManager()
    
    let nameRelay = BehaviorRelay(value: "")
    let explainRelay = BehaviorRelay(value: "")
    let mapPointRelay = BehaviorRelay(value: MapPoint(latitude: 0, longitude: 0))
    
    let viewModel = AddViewModel()

    
    var registerable = false
    var explainText = ""
    var nameText = ""
    var updateCount = 0
    
    var currentPoint: MapPoint? {
        didSet{
            if updateCount == 0 {
                self.mapPointRelay.accept(currentPoint!)
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: currentPoint!.latitude, lng: currentPoint!.longitude)
                marker.mapView = self.mapView
                moveToPoint(latitude: currentPoint!.latitude, longitude: currentPoint!.longitude)
                updateCount += 1
                bindViewModel()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIs()
        
    }
    
    func bindViewModel(){
        
        
        
        
        let input = AddViewModel.Input(name: nameRelay, explainText: explainRelay, point: mapPointRelay)
        let output = viewModel.transfrom(input: input)
        
        
        output.able.subscribe(onNext: { able in
            self.registerable = able
        }).disposed(by: disposeBag)
        
    }
    
    
    
    func setUIs() {
        
        setTextField()
        setTextView()
        setMapView()
        backButton.rx.tap.subscribe(onNext : {
            self.dismiss(animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
        
        registerButton.rx.tap.subscribe(onNext: {
            if self.registerable {
                print("가능")
            }
            else {
                self.nameTextField.becomeFirstResponder()
                self.nameTextField.setBorder(borderColor: .red, borderWidth: 1.0)
            }
            
        }).disposed(by: disposeBag)
        
        
    }
    
    func setTextField() {
        nameTextField.makeRounded(cornerRadius: 7)
        nameTextField.setBorder(borderColor: .black, borderWidth: 1.0)
        
        nameTextField.rx.text.subscribe(onNext : { text in
            if text != "" {
                self.nameTextField.setBorder(borderColor: .black, borderWidth: 1.0)
            }
            self.nameRelay.accept(text ?? "")
            
        },onDisposed: {
            
        }).disposed(by: disposeBag)
    }
    
    func setTextView(){
        
        explainTextView.makeRounded(cornerRadius: 15)
        explainTextView.setBorder(borderColor: .black, borderWidth: 1.0)
        explainTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        explainTextView.rx.text.subscribe(onNext : { text in
            self.explainRelay.accept(text ?? "")
            
        },onDisposed: {
            
        }).disposed(by: disposeBag)
        
        explainTextView.delegate = self // txtvReview가 유저가 선언한 outlet
        explainTextView.text = "설명은 선택사항입니다."
        explainTextView.textColor = UIColor.lightGray
    }
    
    func setMapView(){
        
        mapContainView.makeRounded(cornerRadius: 15)
        mapContainView.addSubview(mapView)
        mapView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        //        LocationManager Setting
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
    }
    
    func moveToPoint(latitude: Double, longitude: Double){
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
        mapView.moveCamera(cameraUpdate)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}


extension AddVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        if let coor = manager.location?.coordinate {
            currentPoint = MapPoint(latitude: coor.latitude, longitude: coor.longitude)
            
            self.locationManager.stopUpdatingLocation()
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


extension AddVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "설명은 선택사항입니다."
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    
}

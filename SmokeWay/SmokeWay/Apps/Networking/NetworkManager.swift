//
//  NetworkManager.swift
//  SmokeWay
//
//  Created by 이주혁 on 2021/05/01.
//

import Foundation

import Firebase
import RxSwift

protocol NetworkManagerType {
    func fetchTotalSmokingPlaceList(completion: @escaping (NetworkResult<Any>) -> Void)
    func addSmokingPlaceList(name: String, mapPoint: MapPoint, detail: String, completion: @escaping (Bool) -> Void)
    func convertMapPointToAddress(mapPoint: MapPoint, completion: @escaping (NetworkResult<Any>) -> Void)
}


struct NetworkManager: NetworkManagerType {
    static let shared: NetworkManager = NetworkManager()
    private var ref: DatabaseReference!
    
    private init() {
        ref = Database.database().reference().child("smokingPlaces")
    }
    
    internal func fetchTotalSmokingPlaceList(completion: @escaping (NetworkResult<Any>) -> Void) {
        
        ref.getData { error, snapshot in
            if let error = error {
                print("Error getting data \(error)")
                completion(.requestErr(error))
            }
            else if snapshot.exists() {
                let enumerated = snapshot.children
                var result: [SmokingPlace] = []
                
                while let rest = enumerated.nextObject() as? DataSnapshot {
                    let key = rest.key
                    let dictionary = rest.value as? [String: Any] ?? [:]
                    let detail: String = dictionary["detail"] as? String ?? ""
                    let name: String = dictionary["name"] as? String ?? ""
                    
                    let mapPointDic = rest.childSnapshot(forPath: "mapPoint").value as? [String: Any] ?? [:]
                    let longitude = mapPointDic["longitude"] as? Double ?? 0
                    let latitude = mapPointDic["latitude"] as? Double ?? 0
                    
                    print(key)
                    print(name)
                    print(longitude, latitude)
                    print(detail)
                    //
                    //
                    //
                    completion(.success(result))
                }
            }
            else {
                print("No data available")
            }
        }
    }
    
    func addSmokingPlaceList(name: String,
                             mapPoint: MapPoint,
                             detail: String,
                             completion: @escaping (Bool) -> Void) {
        guard let placeId = ref.childByAutoId().key else { return }
        
        let mapPointDic: [String: Any] = [ "latitude"  : mapPoint.latitude,
                                           "longitude" : mapPoint.longitude ]
        
        let places: [String: Any] = [ "name"    :   name,
                                      "mapPoint" : mapPointDic,
                                      "detail"  :   "detaildetail"  ]
        
        
        let updateValues = [ "/\(placeId)" : places ]
        ref.updateChildValues(updateValues) { error, _ in
            guard let error = error else {
                completion(false)
                return
            }
            completion(false)
        }
    }
    
    func convertMapPointToAddress(mapPoint: MapPoint, completion: @escaping (NetworkResult<Any>) -> Void) {
        
    }
}

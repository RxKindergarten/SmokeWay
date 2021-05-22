//
//  DataProvider.swift
//  SmokeWay
//
//  Created by 이주혁 on 2021/05/22.
//

import Foundation

import RxSwift


protocol DataProvierType {
    func rxFetchSmokingPlaceLists() -> Observable<[SmokingPlace]>
    func rxAddSmokingPlace() -> Observable<Void>
}

struct DataProvider {
    static let shared: DataProvider = DataProvider(dependency: NetworkManager.shared)
    private var network: NetworkManagerType
    
    private init(dependency: NetworkManagerType) {
        network = dependency
    }
    
}

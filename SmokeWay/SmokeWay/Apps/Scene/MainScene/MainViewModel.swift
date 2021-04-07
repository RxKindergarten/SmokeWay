//
//  MainViewModel.swift
//  SmokeWay
//
//  Created by 이주혁 on 2021/03/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelType  {
    associatedtype Input
    associatedtype Output
    
//    func transform(input: Input) -> Output
}

class MainViewModel: MainViewModelType {
    
    var smokingPlaces: [SmokingPlace] = [SmokingPlace(idx: 1, name: "1", mapPoint: MapPoint(latitude: 37.0, longitude: 127.0), detail: ["test1"]),
                                         SmokingPlace(idx: 2, name: "2", mapPoint: MapPoint(latitude: 3.0, longitude: 127.0), detail: ["test2"]),
                                         SmokingPlace(idx: 3, name: "3", mapPoint: MapPoint(latitude: 39.0, longitude: 105.0), detail: ["test3"]),
                                         SmokingPlace(idx: 4, name: "4", mapPoint: MapPoint(latitude: 35.0, longitude: 121.0), detail: ["test4"])
    ]
    let disposeBag = DisposeBag()
    
    struct Input {
        let ready: Driver<Bool>
        let currentPoint: Observable<MapPoint>
//        let selectedPoint: Driver<MapPoint>
//        let expansion: Observable<Expansion>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let surroundInfos: Driver<[SmokingPlace]>
//        let sortedInfos: Driver<[SmokingPlace]>
//        let exapansion: Driver<Expansion>
//        let detailInfo: Driver<SmokingPlace>
        
    }
    
    
    struct Dependencies {
        
    }
    
    func getNearbyPlaces(latitude: Double,longitude: Double) -> [SmokingPlace] {
        var nearBy :[SmokingPlace] = []
        for place in smokingPlaces {
            if place.mapPoint.latitude >= latitude*0.9 && place.mapPoint.latitude >= latitude*1.1
                && place.mapPoint.longitude >= longitude*0.9  && place.mapPoint.longitude >= longitude*1.1 {
                nearBy.append(place)
            }
        }
        return nearBy
    }
    
    
    func transform(input: Input) -> Output {

        let loading = input.ready
        var surroudInfoList : [SmokingPlace] = []
        let surroundRelay = BehaviorRelay(value: [SmokingPlace(idx: 0, name: "1", mapPoint: MapPoint(latitude: 0.0, longitude: 0.0), detail: ["123"])])


        
        input.currentPoint
            .subscribe(onNext: { mapPoint in
                surroudInfoList = []
                for place in self.smokingPlaces {
                    if place.mapPoint.latitude >= mapPoint.latitude*0.9 && place.mapPoint.latitude >= mapPoint.latitude*1.1
                        && place.mapPoint.longitude >= mapPoint.longitude*0.9  && place.mapPoint.longitude >= mapPoint.longitude*1.1 {
                        print(place.mapPoint.latitude)
                        print(mapPoint.latitude)
                        surroudInfoList.append(place)
                        
                    }
                }
                surroundRelay.accept(surroudInfoList)
            }).disposed(by: disposeBag)

        print("transforming")
        print(surroudInfoList)
        return Output(loading: loading, surroundInfos: surroundRelay.asDriver(onErrorJustReturn: []))
    }


    
    
    
}



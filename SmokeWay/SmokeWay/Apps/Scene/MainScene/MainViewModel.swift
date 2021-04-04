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
    
    
    
    struct Input {
        let ready: Observable<Bool>
        let currentPoint: Driver<MapPoint>
        let selectedPoint: Driver<MapPoint>
        let expansion: Observable<Expansion>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let surroundInfos: Driver<[SmokingPlace]>
        let sortedInfos: Driver<[SmokingPlace]>
        let exapansion: Driver<Expansion>
        let detailInfo: Driver<SmokingPlace>
        
    }
    
    
    struct Dependencies {
        
    }
    
//    func transform(input: Input) -> Output {
//
//        let loading = input.ready
//
//        var surroudInfoList : [SmokingPlace] = []
//        var curpos: MapPoint
//
//        let currentPosition = input.currentPoint { (latitude, longitude) in
//            return MapPoint(latitude: latitude, longitude: longitude)
//
//
//        }
//
//        input.currentPoint
//            .subscribe(onNext: {_ in
//                currentPosition = input.currentPoint
//
//            })
//
//        for place in smokingPlaces {
//            if place.mapPoint.latitude >= currentPosition.lati
//        }
//
//
//
//
//        return Output(loading: loading, surroundInfos: surroundInfos, sortedInfos: <#T##Driver<[SmokingPlace]>#>, exapansion: <#T##Driver<Expansion>#>, detailInfo: <#T##Driver<SmokingPlace>#>)
//
//
//
//    }


    
    
    let smokingPlaces: [SmokingPlace] = []
}



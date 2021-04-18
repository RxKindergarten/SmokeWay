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
//        let ready: Observable<Bool>
//        let currentPoint: Driver<MapPoint>
        let selectedPoint: Driver<MapPoint>
        let swipeViewGesture: Driver<Expansion>
    }
    
    struct Output {
//        let loading: Driver<Bool>
//        let surroundInfos: Driver<[SmokingPlace]>
//        let sortedInfos: Driver<[SmokingPlace]>
        let exapansion: Driver<Expansion>
//        let detailInfo: Driver<SmokingPlace>
        
    }
    
    
    struct Dependencies {
        
    }
    
    func transform(input: Input) -> Output {
        
    
        let expansion = configureExpansion(input.selectedPoint, input.swipeViewGesture)
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
        
        return Output(exapansion: expansion)
    }

    
    func configureExpansion(_ selectedPoint: Driver<MapPoint>,
                            _ swipeViewGesture: Driver<Expansion>) -> Driver<Expansion> {
        let validMapPoints = smokingPlaces.map{ $0.mapPoint }
        
        let selectedValidInput = selectedPoint.map { return validMapPoints.contains($0) }
        
        let expansion = Observable.combineLatest(selectedValidInput.asObservable(),
                                                 swipeViewGesture.asObservable()) { (isSelected, swipe) -> Expansion in
            
            if isSelected {
                return .middle
            }
            
            switch swipe {
            case .high:
                return .high
            case .low:
                return .low
            case .move(let distance):
                return .move(distance: distance)
            case .middle:
                return .middle
            }
        }
        
        return expansion.asDriver(onErrorJustReturn: .move(distance: 0))
    }

    
    
    let smokingPlaces: [SmokingPlace] = []
}



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
    
    func transform(input: Input) -> Output
}

class MainViewModel: MainViewModelType {
//    37.49617587529766, longitude: 127.01892512111017))
    var smokingPlaces: [SmokingPlace] = [SmokingPlace(idx: 1, name: "1", mapPoint: MapPoint(latitude: 37.49617587529766, longitude: 127.015), detail: ["test1"]),
                                         SmokingPlace(idx: 2, name: "2", mapPoint: MapPoint(latitude: 37.48, longitude: 127.01892512111017), detail: ["test2"]),
                                         SmokingPlace(idx: 3, name: "3", mapPoint: MapPoint(latitude: 39.0, longitude: 105.0), detail: ["test3"]),
                                         SmokingPlace(idx: 4, name: "4", mapPoint: MapPoint(latitude: 35.0, longitude: 121.0), detail: ["test4"])
    ]
    let disposeBag = DisposeBag()
    
    struct Input {
        let ready: Driver<Bool>
        let currentPoint: Observable<MapPoint>
        let selectedPoint: Driver<MapPoint>
        let swipeViewGesture: Driver<Expansion>
        let itemSelectEvent: Driver<IndexPath>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let surroundInfos: Driver<[SmokingPlace]>
        let sortedInfos: Driver<[SmokingPlace]>
        let exapansion: Driver<Expansion>
        let selectEvent: Driver<Bool>
        let detailInfo: Driver<SmokingPlace>
        
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
                print("currentPointRelayCalled")
                surroudInfoList = []
                for place in self.smokingPlaces {
                    if place.mapPoint.latitude >= mapPoint.latitude*0.9 && place.mapPoint.latitude <= mapPoint.latitude*1.1
                        && place.mapPoint.longitude >= mapPoint.longitude*0.9  && place.mapPoint.longitude <= mapPoint.longitude*1.1 {
                        surroudInfoList.append(place)
                        
                    }
                }
             
                surroundRelay.accept(surroudInfoList)
            }).disposed(by: disposeBag)
        
        let sortedInfos = configureSortedInfos(input.selectedPoint)
        let selectEvent = configureSelectEvent(input.selectedPoint)
        let detailInfo = configureItemSelect(input.itemSelectEvent)
        
        return Output(loading: loading,
                      surroundInfos: surroundRelay.asDriver(onErrorJustReturn: []),
                      sortedInfos: sortedInfos,
                      exapansion: input.swipeViewGesture,
                      selectEvent: selectEvent,
                      detailInfo: detailInfo)
    }
    
    
    private func configureSelectEvent(_ selectedPoint: Driver<MapPoint>) -> Driver<Bool> {
        let validMapPoints = smokingPlaces.map{ $0.mapPoint }
        
        return selectedPoint.map {
            return validMapPoints.contains($0)
        }
    }
    
    private func configureSortedInfos(_ selectedPoint: Driver<MapPoint>) -> Driver<[SmokingPlace]> {
        
        return selectedPoint.map{ [weak self] point -> [SmokingPlace] in
            guard let strongSelf = self else {
                return []
            }
            
            if let selectedPointIndex = strongSelf.smokingPlaces.firstIndex(where: { (place) -> Bool in
                return place.mapPoint == point
            }) {
                var tmpArr = strongSelf.smokingPlaces
                let selectedPlace = tmpArr.remove(at: selectedPointIndex)
                return [selectedPlace] + tmpArr
            }
            else {
                return strongSelf.smokingPlaces
            }
        }
    }
    
    private func configureItemSelect(_ selectEvent: Driver<IndexPath>) -> Driver<SmokingPlace> {
        return selectEvent.map{ [weak self] in return self!.smokingPlaces[$0.row] }
    }

        
    
        
}



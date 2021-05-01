//
//  DetailViewModel.swift
//  SmokeWay
//
//  Created by 이주혁 on 2021/04/25.
//

import Foundation

import RxSwift
import RxCocoa

class DetailViewModel: MainViewModelType {
   
    
    typealias Input = SmokingPlace
    private let smokingPlace: Input
    
    struct Output {
        var nameEvent: Driver<String>
        var detailEvent: Driver<[String]>
        var addressEvet: Driver<String>
        var mapPoint: Driver<MapPoint>
    }
    
    init(smokingPlace: Input) {
        self.smokingPlace = smokingPlace
        
    }
    
    internal func transform() -> Output {
        let nameEvent = Driver.just(smokingPlace.name)
        let detailEvent = Driver.just(smokingPlace.detail)
        let addressEvent = transformAdressTo(mapPoint: smokingPlace.mapPoint)
        let mapPoint = Driver.just(smokingPlace.mapPoint)
        
        return Output(nameEvent: nameEvent,
                      detailEvent: detailEvent,
                      addressEvet: addressEvent,
                      mapPoint: mapPoint)
    }
    
    internal func transform(input: SmokingPlace) -> Output {
        let nameEvent = Driver.just(input.name)
        let detailEvent = Driver.just(input.detail)
        let addressEvent = transformAdressTo(mapPoint: input.mapPoint)
        let mapPoint = Driver.just(input.mapPoint)
        
        return Output(nameEvent: nameEvent,
                      detailEvent: detailEvent,
                      addressEvet: addressEvent,
                      mapPoint: mapPoint)
    }
    
    private func transformAdressTo(mapPoint: MapPoint) -> Driver<String> {
        return Driver.just(mapPoint).map{
            return "\($0)"
        }
    }
}

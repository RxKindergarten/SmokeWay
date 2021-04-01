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
        let ready: Driver<Bool>
        let currentPoint: Driver<MapPoint>
        let selectedPoint: Driver<MapPoint>
        let expansion: Driver<Expansion>
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
//        
//        
//        
//
//        
//   
//    }
//    
//    
//    
//    
//    let smokingPlaces: [SmokingPlace]
}



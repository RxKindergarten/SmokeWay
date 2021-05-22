//
//  AddViewModel.swift
//  SmokeWay
//
//  Created by Yunjae Kim on 2021/05/22.
//

import Foundation
import RxSwift
import RxCocoa


struct AddViewModel {
    
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let name: BehaviorRelay<String>
        let explainText: BehaviorRelay<String>
        let point: BehaviorRelay<MapPoint>
    }
    
    struct Output {
        let able: BehaviorRelay<Bool>
        
    }
    
    func transfrom(input: Input) -> Output {
        
        var ableValue = false
        
        let ableRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        
        input.name.subscribe(onNext: { text in
            if text == ""  {
                ableRelay.accept(false)
            }
            else {
                ableRelay.accept(true)
            }
            
        }).disposed(by: disposeBag)
        
        
        return Output(able: ableRelay)
        
        
    }
    
    
    
}

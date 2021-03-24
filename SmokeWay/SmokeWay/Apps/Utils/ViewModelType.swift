//
//  ViewModelType.swift
//  SmokeWay
//
//  Created by Yunjae Kim on 2021/03/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
}

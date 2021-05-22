//
//  NetworkResult.swift
//  SmokeWay
//
//  Created by 이주혁 on 2021/05/22.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}

//
//  ResourceAccessData.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/7/4.
//

import Foundation

struct ResourceAccessData: Decodable {
    struct Accessor: Decodable {
        let identifier: String
        let identifierType: String
    }
    let stream: String
    let accessor: Accessor
    let tccService: String?
    let identifier: String
    let kind: String
    let timestamp: String
    let version: Int
}

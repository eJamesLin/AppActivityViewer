//
//  NetworkActivity.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/6/30.
//

import Foundation

typealias AppActivities = [String: [NetworkActivity]]

/// https://developer.apple.com/documentation/foundation/urlrequest/
struct NetworkActivity: Decodable, Hashable {
    
    let domain: String
    let effectiveUserId: Int
    let domainType: Int
    let timeStamp: Date
    let initiatingApp: String
    let context: String
    let hits: Int
    let domainOwner: String
    let initiatedType: InitiatedType
    let firstTimeStamp: Date

    enum CodingKeys: String, CodingKey {
        case domain
        case effectiveUserId
        case domainType
        case timeStamp
        case initiatingApp = "hasApp.bundleName"
        case context
        case hits
        case domainOwner
        case initiatedType
        case firstTimeStamp
    }

    enum InitiatedType: String, Decodable {
        case AppInitiated
        case NonAppInitiated
    }
}

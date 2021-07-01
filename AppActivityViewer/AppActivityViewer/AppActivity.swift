//
//  AppActivity.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/6/30.
//

import Foundation

typealias AppActivities = [String: [AppActivity]]

struct AppActivity: Decodable, Hashable {
    
    let domain: String
    let effectiveUserId: Int
    let domainType: Int
    let timeStamp: Date
    let context: String
    let hits: Int
    let domainOwner: String
    let initiatedType: InitiatedType
    let firstTimeStamp: Date

    enum InitiatedType: String, Decodable {
        case AppInitiated
        case NonAppInitiated
    }
}

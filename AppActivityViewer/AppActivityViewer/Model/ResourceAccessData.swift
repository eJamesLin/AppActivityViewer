//
//  ResourceAccessData.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/7/4.
//

import Foundation

/// https://developer.apple.com/documentation/foundation/urlrequest/inspecting_app_activity_data
struct ResourceAccessData: Decodable, Identifiable {
    var id: String {
        identifier
    }

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

    var resourceDisplayName: String {
        switch stream {
        case "com.apple.privacy.accounting.stream.tcc":
            if let service = tccService, service.hasPrefix("kTCCService") {
                return service.deletingPrefix("kTCCService")
            } else {
                return "Sensor or user data"
            }
        case "com.apple.privacy.accounting.stream.replay-kit":
            return "Screen sharing"
        case "com.apple.privacy.accounting.stream.location":
            return "Location"
        default:
            return stream
        }
    }
}

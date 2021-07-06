//
//  ReportParser.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/7/4.
//

import Foundation

enum ReportError: Error {
    case error
}

/// https://developer.apple.com/documentation/foundation/urlrequest/inspecting_app_activity_data
enum ReportParser {

    static func parse(content: String) async throws -> ([ResourceAccessData], NetworkActivities) {
        guard let resourceStart = content.range(of: "<metadata>\"}"),
              let resourceEnd = content.range(of: "<end-of-section>\"}") else {
                  throw ReportError.error
              }

        async let resource = parseResourceAccess(content: content[resourceStart.upperBound..<resourceEnd.upperBound])
        async let network = parseNetworkActivity(content: content[resourceEnd.upperBound...])
        return try await (resource, network)
    }

    // FIXME: Use the new Swift concurrency to replace GCD
    static func parseResourceAccess(content: Substring) async throws -> [ResourceAccessData] {
        typealias Continuation = CheckedContinuation<[ResourceAccessData], Error>
        return try await withCheckedThrowingContinuation { (continuation: Continuation) in
            DispatchQueue.global(qos: .userInitiated).async {

                let array = content.split(separator: "\n")[0...100]
//                    .dropLast() // drop { "_marker" : "<end-of-section>" }

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                let resourcesAccess = try? array.map {
                    try decoder.decode(ResourceAccessData.self, from: $0.data(using: .ascii)!)
                }
                if let resourcesAccess = resourcesAccess {
                    continuation.resume(returning: resourcesAccess)
                } else {
                    continuation.resume(throwing: ReportError.error)
                }
            }
        }
    }

    // FIXME: Use the new Swift concurrency to replace GCD
    static func parseNetworkActivity(content: Substring) async throws -> NetworkActivities {
        typealias Continuation = CheckedContinuation<NetworkActivities, Error>
        return try await withCheckedThrowingContinuation { (continuation: Continuation) in
            DispatchQueue.global(qos: .userInitiated).async {

                guard let jsonData = content.data(using: .ascii) else {
                    continuation.resume(throwing: ReportError.error)
                    return
                }

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                if let networkActivities = try? decoder.decode(NetworkActivities.self, from: jsonData) {
                    continuation.resume(returning: networkActivities)
                } else {
                    continuation.resume(throwing: ReportError.error)
                }
            }
        }
    }
}

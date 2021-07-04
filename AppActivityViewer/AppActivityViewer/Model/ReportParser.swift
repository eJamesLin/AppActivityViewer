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
class ReportParser {

    private var resources: [ResourceAccessData]?
    private var networks: NetworkActivities?

    // FIXME: Use the new Swift concurrency to replace GCD
    func parse(content: String) async throws -> ([ResourceAccessData], NetworkActivities) {

        guard let resourceStart = content.range(of: "<metadata>\"}"),
              let resourceEnd = content.range(of: "<end-of-section>\"}") else {
                  throw ReportError.error
              }

        typealias Continuation = CheckedContinuation<([ResourceAccessData], NetworkActivities), Error>

        return try await withCheckedThrowingContinuation { (continuation: Continuation) in
            let dispatchGroup = DispatchGroup()

            dispatchGroup.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                self.resources = self.parseResourceAccess(
                    content: content[resourceStart.upperBound..<resourceEnd.upperBound]
                )
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                self.networks = self.parseNetworkActivity(
                    content: content[resourceEnd.upperBound...]
                )
                dispatchGroup.leave()
            }

            dispatchGroup.notify(queue: .main) {
                if let resources = self.resources,
                   let networks = self.networks {
                    continuation.resume(returning: (resources, networks))
                } else {
                    continuation.resume(throwing: ReportError.error)
                }
            }
        }
    }

    func parseResourceAccess(content: Substring) -> [ResourceAccessData]? {
        let array = content.split(separator: "\n")
            .dropLast() // drop { "_marker" : "<end-of-section>" }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try? array.map {
            try decoder.decode(ResourceAccessData.self, from: $0.data(using: .ascii)!)
        }
    }

    func parseNetworkActivity(content: Substring) -> NetworkActivities? {
        guard let jsonData = content.data(using: .ascii) else { return nil }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(NetworkActivities.self, from: jsonData)
    }
}

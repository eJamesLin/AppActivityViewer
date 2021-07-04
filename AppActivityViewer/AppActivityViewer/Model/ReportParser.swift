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

enum ReportParser {
    static func parse(content: String) async throws -> AppActivities {
        typealias AppActivityContinuation = CheckedContinuation<AppActivities, Error>
        return try await withCheckedThrowingContinuation { (continuation: AppActivityContinuation) in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let range = content.range(of: "<end-of-section>\"}") else {
                    continuation.resume(throwing: ReportError.error)
                    return
                }

                let jsonString = content[range.upperBound...]
                guard let jsonData = jsonString.data(using: .ascii) else {
                    continuation.resume(throwing: ReportError.error)
                    return
                }

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                do {
                    let activities = try decoder.decode(AppActivities.self, from: jsonData)
                    continuation.resume(returning: activities)
                } catch {
                    continuation.resume(throwing: ReportError.error)
                }
            }
        }
    }
}

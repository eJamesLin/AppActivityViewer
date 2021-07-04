//
//  ReportParser.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/7/4.
//

import Foundation

enum ReportParser {
    enum DataError: Error {
        case formatError
    }

    static func parse(content: String) async throws -> AppActivities {
        guard let range = content.range(of: "<end-of-section>\"}") else { throw DataError.formatError }

        let jsonString = content[range.upperBound...]
        guard let jsonData = jsonString.data(using: .ascii) else { throw DataError.formatError }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode(AppActivities.self, from: jsonData)
    }
}

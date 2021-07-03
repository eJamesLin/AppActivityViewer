//
//  ViewModel.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/7/3.
//

import Foundation

enum ViewModel {

    enum DataError: Error {
        case formatError
    }

    static func importReport(fileName: String) async throws -> AppActivities {
        let url = URL.appGroupSharedFolder().appendingPathComponent(fileName)
        let content = try String(contentsOf: url)
        guard let range = content.range(of: "<end-of-section>\"}") else { throw DataError.formatError }

        let jsonString = content[range.upperBound...]
        guard let jsonData = jsonString.data(using: .ascii) else { throw DataError.formatError }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode(AppActivities.self, from: jsonData)
    }

    static func jsonFileListInApp() async throws -> [String] {
        let folder = URL.appGroupSharedFolder()
        return try FileManager.default.contentsOfDirectory(atPath: folder.path).filter {
            $0.hasSuffix(".json")
        }
    }
}

//
//  Helper.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/7/3.
//

import Foundation

enum Helper {
    static func importReport(fileName: String) async throws -> ([ResourceAccessData], NetworkActivities) {
        let url = URL.appGroupSharedFolder().appendingPathComponent(fileName)
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let content = String(data: data, encoding: .ascii) else { throw ReportError.error }
        return try await ReportParser.parse(content: content)
    }

    static func jsonFileListInApp() async throws -> [String] {
        let folder = URL.appGroupSharedFolder()
        return try FileManager.default.contentsOfDirectory(atPath: folder.path).filter {
            $0.hasSuffix(".json")
        }
    }

    static func filteredApps(networkActivities: NetworkActivities, searchText: String) -> [String] {
        Array(networkActivities.keys).filter {
            searchText.isEmpty
            ? true
            : $0.lowercased().contains(searchText.lowercased())
        }
    }
}

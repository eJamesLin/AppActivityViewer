//
//  Helper.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/7/3.
//

import Foundation

enum Helper {
    static func importReport(fileName: String) async throws -> AppActivities {
        let url = URL.appGroupSharedFolder().appendingPathComponent(fileName)
        let content = try String(contentsOf: url)
        return try await ReportParser.parse(content: content)
    }

    static func jsonFileListInApp() async throws -> [String] {
        let folder = URL.appGroupSharedFolder()
        return try FileManager.default.contentsOfDirectory(atPath: folder.path).filter {
            $0.hasSuffix(".json")
        }
    }

    static func filteredApps(apps: AppActivities, searchText: String) -> [String] {
        Array(apps.keys).filter {
            searchText.isEmpty
            ? true
            : $0.lowercased().contains(searchText.lowercased())
        }
    }
}

//
//  AppsView.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/6/23.
//

import SwiftUI

struct AppsView: View {

    let fileName: String

    @State private var apps: AppActivities?

    @State private var searchText = ""

    var body: some View {
        ZStack {
            if let apps = apps {
                VStack {
                    SearchBar(text: $searchText, placeholder: "")
                    List {
                        ForEach(filteredApps(apps: apps), id: \.self) { bundleID in
                            NavigationLink(
                                destination: SingleAppView(bundleID: bundleID, activities: apps[bundleID]!),
                                label: { Text(bundleID) }
                            )
                        }

                    }
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle(fileName)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            async {
                try self.apps = await ViewModel.importReport(fileName: fileName)
            }
        }
    }

    func filteredApps(apps: AppActivities) -> [String] {
        Array(apps.keys).filter {
            searchText.isEmpty
            ? true
            : $0.lowercased().contains(searchText.lowercased())
        }
    }
}

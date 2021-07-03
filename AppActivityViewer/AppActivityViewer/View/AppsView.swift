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

    @State private var error: Error?

    @State private var searchText = ""

    var body: some View {
        ZStack {
            if let apps = apps {
                VStack {
                    SearchBar(text: $searchText, placeholder: "")
                    List {
                        ForEach(Helper.filteredApps(apps: apps, searchText: searchText), id: \.self) { bundleID in
                            NavigationLink(
                                destination: SingleAppView(bundleID: bundleID, activities: apps[bundleID]!),
                                label: { Text(bundleID) }
                            )
                        }

                    }
                }
            }
            else if let error = error {
                Text(error.localizedDescription).padding(20)
            }
            else {
                ProgressView()
            }
        }
        .navigationTitle(fileName)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            async {
                do {
                    try self.apps = await Helper.importReport(fileName: fileName)
                } catch {
                    self.error = error
                }
            }
        }
    }
}

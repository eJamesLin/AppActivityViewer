//
//  AppsView.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/6/23.
//

import SwiftUI

struct AppsView: View {

    let fileName: String

    @State private var networkActivities: NetworkActivities?

    @State private var resourcesAccess: [ResourceAccessData]?

    @State private var error: Error?

    @State private var searchText = ""

    var body: some View {
        ZStack {
            if let resourcesAccess = resourcesAccess {
                List {
                    ForEach(resourcesAccess) { resourceAccessData in
                        HStack {
                            Text(resourceAccessData.resourceDisplayName)
                            Text(resourceAccessData.accessor.identifier)
                            Text(resourceAccessData.timestamp)
                        }
                    }
                }
            }
            else if let networkActivities = networkActivities {
                VStack {
                    SearchBar(text: $searchText, placeholder: "")
                    List {
                        ForEach(Helper.filteredApps(networkActivities: networkActivities, searchText: searchText),
                                id: \.self)
                        { bundleID in
                            NavigationLink(
                                destination: SingleAppView(bundleID: bundleID,
                                                           activities: networkActivities[bundleID]!),
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
                    try (self.resourcesAccess, self.networkActivities) = await Helper.importReport(fileName: fileName)
                } catch {
                    self.error = error
                }
            }
        }
    }
}

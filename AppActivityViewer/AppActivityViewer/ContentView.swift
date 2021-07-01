//
//  ContentView.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/6/23.
//

import SwiftUI

struct ContentView: View {

    @State var apps: AppActivities = [:]

    @State var pinnedApps: Set <String> = []

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Pinned Apps")) {
                    ForEach(existedPinnedApps(), id: \.self) { bundleID in
                        NavigationLink(
                            destination: SingleAppView(bundleID: bundleID, activities: apps[bundleID]!),
                            label: { Text(bundleID) }
                        ).contextMenu {
                            Button {
                                pinnedApps.remove(bundleID)
                            } label: {
                                Text("remove pin")
                            }

                        }
                    }
                }
                Section(header: Text("All Apps")) {
                    ForEach(Array(apps.keys), id: \.self) { bundleID in
                        NavigationLink(
                            destination: SingleAppView(bundleID: bundleID, activities: apps[bundleID]!),
                            label: { Text(bundleID) }
                        ).contextMenu {
                            Button {
                                pinnedApps.insert(bundleID)
                            } label: {
                                Text("pin")
                            }

                        }
                    }
                }
            }
            //.listStyle(PlainListStyle())
            .navigationTitle("App Activity Viewer")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(
                    action: {
                        async {
                            await importReport()
                        }},
                    label: {
                        Text("Import")
                    }
                )
            )
        }
    }

    func importReport() async {
        let url = Bundle.main.url(forResource: "app-privacy-report-2021-06-30-01-23", withExtension: "json")!
        let string = try! String(contentsOf: url)
        let range = string.range(of: "<end-of-section>\"}")!
        let jsonString = string[range.upperBound...]
        let jsonData = jsonString.data(using: .ascii)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let appActivities = try! decoder.decode(AppActivities.self, from: jsonData)
        print(appActivities.keys)

        self.apps = appActivities
    }

    func existedPinnedApps() -> [String] {
        var arr: [String] = []
        for bundleID in pinnedApps {
            if apps[bundleID] != nil {
                arr.append(bundleID)
            }
        }
        return arr
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

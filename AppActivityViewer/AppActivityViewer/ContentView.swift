//
//  ContentView.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/6/23.
//

import SwiftUI

struct ContentView: View {

    @State var apps: AppActivities = [:]

    @State private var searchText = "shopping"

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "")
                List {
                    ForEach(
                        Array(apps.keys).filter {
                        searchText.isEmpty
                        ? true
                        : $0.lowercased().contains(searchText.lowercased())
                    },
                        id: \.self
                    ) { bundleID in
                        NavigationLink(
                            destination: SingleAppView(bundleID: bundleID, activities: apps[bundleID]!),
                            label: { Text(bundleID) }
                        )
                    }

                }
                //.listStyle(PlainListStyle())
                .navigationTitle("App Activity Viewer")
                //.navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    trailing: Button(
                        action: {
                            async {
                                await importReport()
                            }
                        },
                        label: {
                            Image(systemName: "book")
                        }
                    )
                )
            }
        }
    }

    func importReport() async {
        let url = Bundle.main.url(forResource: "app-privacy-report-sample", withExtension: "json")!
        let string = try! String(contentsOf: url)
        let range = string.range(of: "<end-of-section>\"}")!
        let jsonString = string[range.upperBound...]
        let jsonData = jsonString.data(using: .ascii)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let appActivities = try! decoder.decode(AppActivities.self, from: jsonData)
        self.apps = appActivities
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

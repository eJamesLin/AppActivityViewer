//
//  SingleAppView.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/7/2.
//

import SwiftUI

struct SingleAppView: View {
    
    let bundleID: String
    
    let activities: [NetworkActivity]
    
    var body: some View {
        List(activities, id: \.self) { activity in
            NavigationLink(
                destination: NetworkActivityView(networkActivity: activity),
                label: { Text(activity.domain) }
            )
        }
        .navigationTitle(bundleID)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NetworkActivityView: View {

    let networkActivity: NetworkActivity

    var body: some View {
        List {
            ForEach(Array(Mirror(reflecting: networkActivity).children), id: \.label) { child in
                HStack {
                    Text(child.label ?? "")
                    Spacer()
                    Text(String(describing: child.value))
                }
            }
        }
    }
}

//
//  SingleAppView.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/7/2.
//

import SwiftUI

struct SingleAppView: View {
    
    let bundleID: String
    
    let activities: [AppActivity]
    
    var body: some View {
        List(activities, id: \.self) { activity in
            Text(activity.domain)
        }
        .navigationTitle(bundleID)
        .navigationBarTitleDisplayMode(.inline)
    }
}

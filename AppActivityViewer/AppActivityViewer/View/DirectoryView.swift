//
//  DirectoryView.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/7/3.
//

import SwiftUI

struct DirectoryView: View {

    @State var fileList: [String]?

    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                if let fileList = fileList {
                    if fileList.isEmpty {
                        Color.clear // force ZStack to fill parent
                        EmptyView()
                    } else {
                        List {
                            Section(header: Text("Reports in directory")) {
                                ForEach(fileList, id: \.self) { file in
                                    NavigationLink(
                                        destination: AppsView(fileName: file),
                                        label: { Text(file) }
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("App Activity Viewer")
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    async {
                        try fileList = await ViewModel.jsonFileListInApp()
                    }
                }
            }
        }
    }
}

struct EmptyView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("No Report in App\n").font(.title)

            Text("1. Turn on activity record\n").font(.title3)

            Text("Settings -> Privacy -> Record App Activity,")
            Text("and turn on Record App Activity\n")

            Text("2. Share to this App\n").font(.title3)
            Text("Click Save App Activity")

            Text("At the share sheet, choose ") + Text("AppActivity").bold()
        }
    }
}

struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryView()
    }
}

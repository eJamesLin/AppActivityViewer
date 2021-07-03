//
//  DirectoryView.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/7/3.
//

import SwiftUI

struct DirectoryView: View {

    @State var fileList: [String]?

    var body: some View {
        NavigationView {
            ZStack {
                if let fileList = fileList, !fileList.isEmpty {
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
                } else {
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
            .navigationTitle("App Activity Viewer")
            .task {
                async {
                    try fileList = await ViewModel.jsonFileListInApp()
                }
            }
        }
    }
}

struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryView()
    }
}

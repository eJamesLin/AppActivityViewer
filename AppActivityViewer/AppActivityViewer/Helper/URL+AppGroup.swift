//
//  URL+AppGroup.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/7/3.
//

import Foundation

extension URL {
    static func appGroupSharedFolder() -> URL {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.cj.AppActivityViewer")!
    }
}

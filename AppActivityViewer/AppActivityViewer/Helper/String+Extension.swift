//
//  String+Extension.swift
//  AppActivityViewer
//
//  Created by cjlin on 2021/7/6.
//

import Foundation

extension String {
    func deletingPrefix(_ prefixString: String) -> String {
        guard self.hasPrefix(prefixString) else { return self }
        return String(self.dropFirst(prefixString.count))
    }
}

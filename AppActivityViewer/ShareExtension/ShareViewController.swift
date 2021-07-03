//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by cjlin on 2021/7/3.
//

import UIKit
import Social

class ShareViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBOutlet weak var successView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global(qos: .userInitiated).async {
            self.writeFile()
        }
    }

    private func writeFile() {
        let identifier = "public.json"

        let provider = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments?.first
        guard provider?.hasItemConformingToTypeIdentifier(identifier) == true else {
            cancel()
            return
        }

        provider?.loadItem(forTypeIdentifier: identifier, options: nil, completionHandler: { (item, error) in
            guard let url = item as? URL else {
                self.cancel()
                return
            }

            do {
                let data = try Data(contentsOf: url)
                let tmpURL = URL.appGroupSharedFolder().appendingPathComponent(url.lastPathComponent)
                try data.write(to: tmpURL, options: .atomic)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    self.successView.isHidden = false

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                    }
                }
            } catch {
                self.cancel()
            }
        })
    }

    private func cancel() {
        let error = NSError(domain: "", code: 0, userInfo: nil)
        extensionContext?.cancelRequest(withError: error)
    }
}

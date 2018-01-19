//
//  VRMDisplayViewController.swift
//  VRM App
//
//  Created by Neil Francis Hipona on 1/15/18.
//  Copyright © 2018 Neil Francis Hipona. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class VRMDisplayViewController: UIViewController {
    
    var wkWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        
        let wkUScript = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        
        wkWebView = WKWebView(frame: self.view.frame, configuration: wkWebConfig)
        view.addSubview(wkWebView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        VRMAPI.shared.installations(forID: 1039) { (json, error) in
            
            print("json: \(json) -- error: \(error)")

        }
    }
}

//
//  VideoPreviewController.swift
//  Picture_of_The_Day
//
//  Created by Hegde, Prajna on 13/06/22.
//

import Foundation

import Foundation
import WebKit

class VideoPreviewController: UIViewController {
    
    var previewUrlString:String?
    
    var webView: WKWebView!
       
       override func loadView() {
           let webConfiguration = WKWebViewConfiguration()
           webConfiguration.allowsInlineMediaPlayback = true
           webView = WKWebView(frame: .zero, configuration: webConfiguration)
           view = webView
       }
    
       override func viewDidLoad() {
           super.viewDidLoad()
           
           if let urlString = previewUrlString, let url = URL(string: urlString) {
               let request = URLRequest(url: url)
               webView.load(request)
           } else {
               AlertService.showOKAlert(title: "Something went wrong", message: "Please try Again", viewController: self)
           }
       }
}

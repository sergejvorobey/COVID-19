//
//  NewsWebSiteViewController.swift
//  COVID-19
//
//  Created by Sergey Vorobey on 11/04/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import WebKit

class NewsWebSiteViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let topItem = navigationController?.navigationBar.topItem {
//            topItem.backBarButtonItem = UIBarButtonItem(title: "",
//                                                        style: .plain,
//                                                        target: nil,
//                                                        action: nil)
//        }
        
        guard let url = URL(string: "https://news.rambler.ru/") else { return }
        let request = URLRequest(url: url)
        
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
        webView.resignFirstResponder()
    }
}

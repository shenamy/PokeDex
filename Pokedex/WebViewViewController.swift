//
//  WebViewViewController.swift
//  Pokedex
//
//  Created by Boris Yue on 2/17/17.
//  Copyright © 2017 trainingprogram. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController {

    var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = UIWebView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)!, width: view.frame.width, height: view.frame.height))
        view.addSubview(webView)
        let googleUrl = NSURL(string: "https://www.google.com/search?q=" + ProfileViewController.currentPokemon.name)
        let urlRequest = NSURLRequest(url: googleUrl! as URL)
        webView.loadRequest(urlRequest as URLRequest)
    }

}

//
//  ViewController.swift
//  KVODemo
//
//  Created by Usha Natarajan on 8/27/18.
//  Copyright © 2018 Usha Natarajan. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    let estimatedProgress = "estimatedProgress"
    
    var safeTopAnchor:NSLayoutYAxisAnchor{
        if #available(iOS 11.0, *){
            return self.view.safeAreaLayoutGuide.topAnchor
        }else{
            return topLayoutGuide.bottomAnchor
        }
    }
    
    lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(closeWebPage))
        toolBar.tintColor = UIColor.black
        toolBar.isTranslucent = true
        toolBar.backgroundColor = UIColor.white
        toolBar.clipsToBounds = false
        toolBar.setItems([button], animated: true)
        return toolBar
    }()
    
    lazy var webPage:WKWebView = {
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        webView.navigationDelegate = self
        return webView
    }()
    
    lazy var progressLabel:UILabel = {
        let label = UILabel(frame: CGRect(x: (self.view.frame.width / 2) - 50, y: (self.view.frame.height / 2) - 30, width: 120 , height: 30))
        label.textColor = UIColor.black
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == estimatedProgress{
            if (self.webPage.estimatedProgress * 100) == 100{
                DispatchQueue.main.async{
                    self.progressLabel.removeFromSuperview()
                }
                return
            }
            DispatchQueue.main.async{
                self.progressLabel.text = "Loading \(Int(self.webPage.estimatedProgress * 100))%"
            }
        }
    }

    
    deinit{
        self.removeObserver(self, forKeyPath: estimatedProgress)
    }
    
    @IBAction func loadPage(_ sender: Any) {
        
        let url = URL(string: "https://devdawn.wixsite.com/allweather")!
        webPage.addObserver(self, forKeyPath: estimatedProgress, options: .new, context: nil)
        webPage.addSubview(progressLabel)
        webPage.load(URLRequest(url: url))
        self.view.addSubview(webPage)
        self.view.addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        self.constraintsForSafeArea(newView: toolBar)
    }
    
    
    @objc func closeWebPage(){
        webPage.load(URLRequest(url: (URL(string: "about:blank")!)))
        self.webPage.removeFromSuperview()
        self.toolBar.removeFromSuperview()
        
    }
    
    func constraintsForSafeArea(newView:UIView){
        let guide = self.view.safeAreaLayoutGuide
        
        newView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        newView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        newView.topAnchor.constraint(equalTo: self.safeTopAnchor).isActive = true
    }
    
}


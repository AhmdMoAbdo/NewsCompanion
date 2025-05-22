//
//  WebViewController.swift
//  News
//
//  Created by Ahmed on 30/07/2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    // MARK: - Outlet(s)
    @IBOutlet weak var myWebView: WKWebView!
    
    // MARK: - Properties
    let networkIndicator = UIActivityIndicatorView(style: .large)
    let preMadeAlerts = PreMadeAlerts()
    let url: String
    
    // MARK: - Initializer(s)
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupWebView()
    }
    
    // MARK: - Setting up activity indicator
    private func setupActivityIndicator() {
        view.addSubview(networkIndicator)
        networkIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            networkIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            networkIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        networkIndicator.startAnimating()
    }
    
    // MARK: - Setting up web view
    private func setupWebView() {
        guard let url = URL(string: url) else { return }
        myWebView.navigationDelegate = self
        myWebView.load(URLRequest(url: url))
    }
    
    // MARK: - Back Button
    @IBAction func backButtonPressed(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
}

// MARK: - Web delegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        networkIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        present(
            preMadeAlerts.getOkStyleSheetAlert(
                message: Constants.Alerts.webLoadingError,
                action: {
                    self.dismiss(animated: true)
                }
            ),
            animated: true
        )
    }
}

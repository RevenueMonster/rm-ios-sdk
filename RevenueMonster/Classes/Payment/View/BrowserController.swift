//
//  AlipayController.swift
//  RevenueMonster
//
//  Created by yussuf on 7/7/19.
//

import Foundation
import WebKit

class BrowserController: UIViewController {
    
    var checkout: Checkout!
    var url: String = ""
    var urlObservation: NSKeyValueObservation?
    var navbar: UINavigationBar!
    var webPage: UIView!
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    convenience init(checkout: Checkout, url: String) {
        self.init(nibName:nil, bundle:nil)
        self.checkout = checkout
        self.url = url
        self.open()
    }
    
    // This extends the superclass.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // This is also necessary when extending the superclass.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func goBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            self.checkout.onClose()
        }
    }
    
    func open() -> UIViewController {
        /* ******************************* TOP NAVIGATION BAR ******************************* */
        navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: checkout.viewController.view.frame.size.width, height: 44))
        
        let rightButton = UIBarButtonItem(title: "Close", style: UIBarButtonItem.Style.plain, target: self.checkout, action: Selector(("onClose")))
        let leftButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("goBack")))
        
        let navItem = UINavigationItem(title: "RM Checkout")
        navItem.rightBarButtonItem = rightButton
        navItem.leftBarButtonItem = leftButton
        
        navbar.setItems([navItem], animated: true)
        navbar.backgroundColor = UIColor.white
        navbar.setBackgroundImage(UIImage(), for: .default)
        navbar.shadowImage = UIImage()
        navbar.isTranslucent = true
        
        webPage = UIView()
        webPage.backgroundColor = UIColor.white
        webPage.translatesAutoresizingMaskIntoConstraints = false
        
        webPage.frame = CGRect(x: 0, y: 0, width: self.checkout.viewController.view.frame.size.width, height: self.checkout.viewController.view.frame.size.height)
        if #available(iOS 11.0, *) {
            let guide = self.checkout.viewController.view.safeAreaLayoutGuide
            navbar.frame = CGRect(x: 0, y:  guide.layoutFrame.minY, width: checkout.viewController.view.frame.size.width, height: 50)
        }
        webPage.addSubview(navbar)
        /* ******************************* TOP NAVIGATION BAR ******************************* */
        
        /* ******************************* WEB VIEW ******************************* */
        let webConfiguration = WKWebViewConfiguration()
        let customFrame = CGRect(x: 0, y: navbar.frame.maxY, width: self.checkout.viewController.view.frame.size.width, height: self.checkout.viewController.view.frame.size.height - 44)
        webView =  WKWebView (frame: customFrame , configuration: webConfiguration)
        let web = URL(string: url)!
        webView.load(URLRequest(url: web))
        webView.allowsBackForwardNavigationGestures = true
        urlObservation = webView.observe(\.url, changeHandler: { (webView, change) in
            if webView.url?.path.contains("/v1/transaction/web/close") ?? true {
                self.checkout.onClose()
            }
            if webView.url?.path.contains("/v1/transaction/web/alipay") ?? true {
                self.checkout.onClose()
            }
        })
        
        webPage.addSubview(webView)
        /* ******************************* WEB VIEW ******************************* */
        
        self.view = webPage
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
        
        return self
    }
}

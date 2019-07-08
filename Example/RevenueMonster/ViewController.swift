//
//  ViewController.swift
//  RevenueMonster
//
//  Created by myussufz on 05/08/2019.
//  Copyright (c) 2019 myussufz. All rights reserved.
//

import UIKit
import RevenueMonster

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onWeChatPay(_ sender: Any) {
        do {
            try self.checkout(method: Method.WECHATPAY_MY)
        } catch {
            print("error: \(error.localizedDescription).")
        }
    }

    @IBAction func onAliPay(_ sender: Any) {
        do {
            try self.checkout(method: Method.ALIPAY_CN)
        } catch {
            print("error: \(error.localizedDescription).")
        }
    }

    @IBAction func onGrabPay(_ sender: Any) {
        do {
            try self.checkout(method: Method.GRABPAY_MY)
        } catch {
            print("error: \(error.localizedDescription).")
        }
    }

    @IBAction func onBoostPay(_ sender: Any) {
        do {
            try self.checkout(method: Method.BOOST_MY)
        } catch {
            print("error: \(error.localizedDescription).")
        }
    }

    @IBAction func onCheckout(_ sender: Any) {
        do {
            try self.checkout(method: Method.TNG_MY)
        } catch {
            print("error: \(error.localizedDescription).")
        }
    }

    private func convertToDictionary(text: String) throws -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                throw error
            }
        }
        return nil
    }


    private func request(url: String, method: String, body: [String: AnyObject]) throws -> (NSInteger, Data?) {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        var dataResponse: Data?
        var statusCode: NSInteger = 0
        let waitGroup = DispatchSemaphore(value: 0)

        request.httpMethod = method

        do {
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = bodyData
            print("API Request: ", String(decoding: bodyData, as: UTF8.self))
        } catch let error {
            throw error
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Unexpected error: \(error).")
            } else {
                print("API Response: \(String(describing: String(data: data!, encoding: .utf8)!))")
                if let response = response as? HTTPURLResponse {
                    statusCode = response.statusCode
                }
                dataResponse = data
                waitGroup.signal()
            }
        }

        task.resume()
        waitGroup.wait()


        return (statusCode, dataResponse)
    }

    private func checkout(method: RevenueMonster.Method) throws {
        var body: [String: AnyObject] = [:]
        body["type"] = "MOBILE_PAYMENT" as AnyObject
        body["redirectURL"] = "revenuemonster://" as AnyObject
        body["notifyURL"] = "https://dev-rm-api.ap.ngrok.io" as AnyObject

        try Checkout(viewController: self).setEnv(Env.DEVELOPMENT)
            .setWeChatAppID("")
            .pay(method: method, checkoutId: "1562583354320509688", result: Result(viewController: self))

//        do {
//            let url: String = "https://sb-api.revenuemonster.my/demo/payment/online"
//
//            let (statusCode, data) = try self.request(url: url, method: "POST", body: body)
//            if statusCode == 200 {
//                let response = try self.convertToDictionary(text: String(describing: String(data: data!, encoding: .utf8)!))
//                let item = response!["item"] as? Dictionary<String, AnyObject>
//
//                do {
//
//                } catch {
//                    print("error: \(error.localizedDescription).")
//                }
//            }
//        }
//        catch {
//            print("error: \(error.localizedDescription).")
//        }
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

class Result: PaymentResult {
    var viewController: UIViewController

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

	func onPaymentSuccess(transaction: Transaction) {
        print("PAYMENT SUCCESS")
        DispatchQueue.main.async {
            self.alert(message: "Payment Success")
        }
    }

	func onPaymentFailed(error: PaymentError) {
        print("PAYMENT FAILED")
        DispatchQueue.main.async {
            self.alert(message: "Payment Failed")
        }
	}

	func onPaymentCancelled() {
        print("PAYMENT CANCELLED")
        DispatchQueue.main.async {
            self.alert(message: "Payment Cancelled")
        }
	}

    func alert(message: String) {
        let alert = UIAlertController(title: "Status", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("ok")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            @unknown default:
                print("default")
            }}))
        self.viewController.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

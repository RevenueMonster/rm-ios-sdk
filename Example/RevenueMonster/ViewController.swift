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

    @IBAction func onCheckout(_ sender: Any) {
        do {
            try Checkout(viewController: self).setEnv(Env.DEVELOPMENT).setWeChatAppID("")
                .pay(method: Method.WECHATPAY_MY, checkoutId: "1557654536284799806", result: Result())
        } catch {
            print("error: \(error.localizedDescription).")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class Result: PaymentResult {
	func onPaymentSuccess(transaction: Transaction) {
		print("SUCCESS", transaction.getStatus())
	}

	func onPaymentFailed(error: PaymentError) {
		print("FAILED", error.getCode())
	}

	func onPaymentCancelled() {
		print("CANCELLED", "User cancelled payment");
	}
}


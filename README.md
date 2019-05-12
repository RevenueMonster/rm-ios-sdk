# RM SDK for iOS

<!-- [![CI Status](https://img.shields.io/travis/myussufz/RevenueMonster.svg?style=flat)](https://travis-ci.org/myussufz/RevenueMonster)
[![Version](https://img.shields.io/cocoapods/v/RevenueMonster.svg?style=flat)](https://cocoapods.org/pods/RevenueMonster)
[![License](https://img.shields.io/cocoapods/l/RevenueMonster.svg?style=flat)](https://cocoapods.org/pods/RevenueMonster)
[![Platform](https://img.shields.io/cocoapods/p/RevenueMonster.svg?style=flat)](https://cocoapods.org/pods/RevenueMonster) -->

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

RevenueMonster is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RevenueMonster'
```

## Author

Mohamed Yussuf, yussuf@revenuemonster.my

## License
### Checkout Sample Code
```swift
do {
	try Checkout(viewController: self).setEnv(Env.SANDBOX)
		.setWeChatAppID	("<< WeChat Open Platform AppID >>")
		.pay(method: Method.WECHATPAY_MY, checkoutId: "<<Get Checkout Id from API>>", result: Result())
} catch {
		print("error: \(error.localizedDescription).")
}

// Callback Result
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
```

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
pod 'RevenueMonster', '0.1-beta.9'
```

## Author

Mohamed Yussuf, yussuf@revenuemonster.my

## License

### Checkout Sample Code
```swift
do {
	try Checkout(viewController: self)
		.setEnv(<<Environment Parameter>>) // set environment
		.setWeChatAppID	("<< WeChat Open Platform AppID >>") // only use for wechatpay
		.setCardInfo(name: "", cardNo: "", cvcNo: "", expMonth: 1, expYear: 2020, countryCode: "MY", isSave: true) // only use for new card 
		.setToken(token: "<<Card Token>>",cvcNo: "<<Cvc No>>"). // only use if use existing card token
		.setBankCode("<<Set Bank Code>>"). // only use for fpx, get the bank code from open api
		.pay(method: <<Method Parameter>>, checkoutId: "<<Get Checkout Id from API>>", result: Result())
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

### Environment Parameter
- SANDBOX      
- PRODUCTION
<br/>
<br/>
### Method Parameter
- WECHATPAY_MY
- TNG_MY
- BOOST_MY
- ALIPAY_CN
- GRABPAY_MY
- MCASH_MY
- RAZERPAY_MY
- PRESTO_MY
- GOBIZ_MY
- FPX_MY

##### Register `weixin`, `alipay`, `boostapp` in your `URL types`:
1. Go to your `Info.plist`
2. Add `weixin`, `alipay`, `boostapp` to `LSApplicationQueriesSchemes`

## WeChatPay In-App Payment

### Register an App ID on WeChat Open Platform

Before started to do wechat payments, first need to register an App ID on WeChat Open Platform.

##### Add your WeChat App ID to URL scheme:

1. Go to `Targets > Info > URL type > URL Scheme`.
2. Add a new `URL Scheme` :

- For identifier set `weixin`
- For URL Schemes set your App ID.
# ios_in_app_purchase
in app purchase practice

보니까 in app purchase는 코드짜는 것 보다도 웹사이트에서 설정하는 것의 비율이 훨씬 많음


- import `StoreKit`
```swift
        import StoreKit
```
- product id
```swift
        //App을 만들 때 내가 만들던 Product ID
        let productId: String = "paige.ios_PremiumQuotes"
```
- buy premium quote
```swift
        func buyPremiumQuotes() {
                if SKPaymentQueue.canMakePayments() {
                    
                    let paymentRequest: SKMutablePayment = SKMutablePayment()
                    paymentRequest.productIdentifier = productId
                    SKPaymentQueue.default().add(paymentRequest)
                    
                } else {
                    print("User can't make payments")
                }
        }
```
- implement `SKPaymentTransactionObserver`  to detect if user succedeed in payment
```swift
        class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
        
            override func viewDidLoad() {
                super.viewDidLoad()
                SKPaymentQueue.default().add(self)
            }    
            
            //delegate method from SKPaymentQueue
            func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
         
          }
        
        }
```
- delegate method from `SKPaymentTransactionObserver`
```swift
        //Listener for Payment Event, 구매한 것에 대해서 추적. Content를 더 보여주거나 안보여줌.
        func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
            
            for transaction in transactions {
                if transaction.transactionState == .purchased {
                    //Give user permission to access to premium service here
                    showPremiumQuote()
                    
                    UserDefaults.standard.set(true, forKey: productId)
                    
                    print("Transaction Successful")
                    SKPaymentQueue.default().finishTransaction(transaction) //End transaction
                } else if transaction.transactionState == .failed {
                    SKPaymentQueue.default().finishTransaction(transaction)
                    
                    if let error: Error = transaction.error {
                        print("Transaction failed due to error: \(error.localizedDescription)")
                    }
                    
                    //Restore
                } else if transaction.transactionState == .restored {
                 
                     showPremiumQuote()
                     SKPaymentQueue.default().finishTransaction(transaction) //End transaction
                }
            }
            
        }

        func showPremiumQuote(){
            quotesToShow.append(contentsOf: premiumQuotes)
            tableView.reloadData()
        }

        func isPurchased() -> Bool {
            let purchaseStatus: Bool = UserDefaults.standard.bool(forKey: productId)
            if purchaseStatus {
                return true
            }
            return false
        }

        @IBAction func restorePressed(_ sender: UIBarButtonItem) {
            
            //유저가 앱을 다시 다운로드 했을 때, 이전 결제 정보를 다시 가져옴
            SKPaymentQueue.default().restoreCompletedTransactions()
            
        }
```

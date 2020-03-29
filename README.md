# ios_in_app_purchase
in app purchase practice

보니까 in app purchase는 코드짜는 것 보다도 웹사이트에서 설정하는 것의 비율이 훨씬 많음


- import `StoreKit`

        import StoreKit

- product id

        //App을 만들 때 내가 만들던 Product ID
        let productId: String = "paige.ios_PremiumQuotes"

- buy premium quote

        func buyPremiumQuotes() {
                if SKPaymentQueue.canMakePayments() {
                    
                    let paymentRequest: SKMutablePayment = SKMutablePayment()
                    paymentRequest.productIdentifier = productId
                    SKPaymentQueue.default().add(paymentRequest)
                    
                } else {
                    print("User can't make payments")
                }
        }

- implement `SKPaymentTransactionObserver`  to detect if user succedeed in payment

        class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
        
            override func viewDidLoad() {
                super.viewDidLoad()
                SKPaymentQueue.default().add(self)
            }    
            
            //delegate method from SKPaymentQueue
            func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
         
          }
        
        }

- delegate method from `SKPaymentTransactionObserver`

        //Listener for Payment Event
        func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
                
                for transaction in transactions {
                    if transaction.transactionState == .purchased {
                        //Give user permission to access to premium service here
                        showPremiumQuote()
                        //보통 UserDefaults로 처리함
                        UserDefaults.standard.set(true, forKey: productId)
                        
                        print("Transaction Successful")
                        SKPaymentQueue.default().finishTransaction(transaction) //End transaction
                    } else if transaction.transactionState == .failed {
                        SKPaymentQueue.default().finishTransaction(transaction)
                        
                        if let error: Error = transaction.error {
                            print("Transaction failed due to error: \(error.localizedDescription)")
                        }
                        
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

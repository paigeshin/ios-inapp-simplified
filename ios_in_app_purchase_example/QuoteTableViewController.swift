//
//  QuoteTableViewController.swift
//  ios_in_app_purchase_example
//
//  Created by shin seunghyun on 2020/03/29.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {

    //App을 만들 때 내가 만들던 Product ID
    let productId: String = "paige.ios_PremiumQuotes"
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        SKPaymentQueue.default().add(self)
        
        if isPurchased() {
            showPremiumQuote()
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchased() {
            return quotesToShow.count
        }
        return quotesToShow.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        
        if indexPath.row < quotesToShow.count {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Get More Quotes"
            cell.textLabel?.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            cell.accessoryType = .disclosureIndicator //아이콘
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            buyPremiumQuotes()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //실제 구매
    func buyPremiumQuotes() {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest: SKMutablePayment = SKMutablePayment()
            paymentRequest.productIdentifier = productId
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("User can't make payments")
        }
    }
    
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
           
    }



}

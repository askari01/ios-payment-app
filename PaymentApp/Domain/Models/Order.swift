//
//  Order.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

struct CheckoutRequest: Codable {
    let order: Order
    //    let callbacks: Callbacks
    let configuration: Configuration
}

struct Order: Codable {
    let orderId: String
    let amount: Amount
    let orderLines: [OrderLine]
    let customer: Customer
    let transactionInfo: [String: String]
}

struct Amount: Codable {
    let value: Double
    let currency: String
}

struct OrderLine: Codable {
    let itemId: String
    let description: String
    let quantity: Int
    let unitPrice: Double
}

struct Customer: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let billingAddress: Address
    let shippingAddress: Address
}

struct Address: Codable {
    let street: String
    let city: String
    let country: String
    let zipCode: String
}

struct Callbacks: Codable {
    let success: Callback
    let failure: Callback
    let redirect: String
    let notification: String
    let bodyFormat: String?
}

struct Callback: Codable {
    let type: String
    let value: String
}


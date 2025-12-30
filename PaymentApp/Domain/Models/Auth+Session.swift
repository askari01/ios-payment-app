//
//  Auth+Session.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

struct AuthResponse: Decodable {
    let token: String
}

struct CheckoutSessionResponse: Decodable {
    let sessionId: String
    let context: Context
    let order: Order
    //    let callbacks: Callbacks
    let configuration: ConfigurationResponse
}

struct Context: Decodable {
    let browser: Browser
}

struct Browser: Decodable {}

//
//  CheckoutSession.swift
//  PaymentSDK
//
//  Created by Farrukh Askari on 30/12/2025.
//

import Foundation

public struct CheckoutSessionResponse: Decodable {
    public let sessionId: String
    public let context: Context
    public let order: Order
    //    let callbacks: Callbacks
    public let configuration: ConfigurationResponse
}

public struct Context: Decodable {
    public let browser: Browser
}

public struct Browser: Decodable {}

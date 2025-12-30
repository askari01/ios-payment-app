//
//  PaymentMethod.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

struct PaymentMethodsResponse: Decodable {
    let methods: [PaymentMethod]
}

struct PaymentInitiationRequest: Codable {
    let paymentMethodId: String
    let sessionId: String
}

struct PaymentInitiationResponse: Decodable {
    let paymentId: String
    let shopOrderId: String
    let status: String
    let type: String
    let url: String
}

struct Configuration: Codable {
    let paymentType: String
    let paymentDisplayType: String?
    let bodyFormat: String
    let autoCapture: Bool
    let country: String
    let language: String
}

struct ConfigurationResponse: Decodable {
    let paymentType: String
    let paymentDisplayType: String
    let autoCapture: Bool
    let country: String
    let language: String
}

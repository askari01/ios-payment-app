//
//  CheckOutSession.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

struct PaymentMethod: Decodable, Identifiable {
    let id: String
    let type: String
    let name: String
    let description: String
    let logoUrl: String?
    let display: String
    let onInitiatePayment: Action
    let onRenderCheck: Action?
    //    let jsMethodHandler: JSMethodHandler?
    let metadata: [String: String]
}

struct Action: Decodable {
    let type: String
    let value: String?
}

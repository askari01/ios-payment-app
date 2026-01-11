//
//  CheckOutRepository.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

protocol CheckoutRepository: Sendable {
    func createSession(request: CheckoutRequest, token: String) async throws -> CheckoutSessionResponse
}

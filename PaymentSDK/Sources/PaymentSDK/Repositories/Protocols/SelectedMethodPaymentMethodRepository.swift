//
//  SelectedPaymentMethodRepository.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

protocol SelectedPaymentMethodRepository: Sendable {
    func initiatePayment(
        paymentInitiationRequest: PaymentInitiationRequest,
        token: String
    ) async throws -> String
}


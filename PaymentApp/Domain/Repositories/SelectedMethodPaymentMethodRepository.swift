//
//  SelectedPaymentMethodRepository.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

protocol SelectedPaymentMethodRepository {
    func initiatePayment(
        paymentInitiationRequest: PaymentInitiationRequest,
        token: String
    ) async throws -> String
}


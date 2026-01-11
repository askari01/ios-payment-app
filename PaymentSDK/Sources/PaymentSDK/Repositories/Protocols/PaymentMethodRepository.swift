//
//  PaymentMethodRepository.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

protocol PaymentMethodRepository {
    func fetchMethods(sessionId: String, token: String) async throws -> [PaymentMethod]
}

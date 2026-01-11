//
//  AuthRepository.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

protocol AuthRepository: Sendable {
    func authenticate() async throws -> AuthResponse
}

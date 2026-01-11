//
//  PaymentClient.swift
//  PaymentSDK
//
//  Created by Farrukh Askari on 11/01/2026.
//

import Foundation

public actor PaymentClient {
    private let api: APIClient
    private let authRepo: AuthRepository
    private let checkoutRepo: CheckoutRepository
    private let paymentMethodRepo: PaymentMethodRepository
    private let selectedPaymentMethodRepo: SelectedPaymentMethodRepository
    
    private var token: String?
    
    public init(username: String, password: String, baseURL: URL) {
        self.api = URLSessionAPIClient()
        
        struct SDKCredentialStore: CredentialStore {
            let username: String
            let password: String
        }
        let creds = SDKCredentialStore(username: username, password: password)
        
        self.authRepo = AuthRepositoryImpl(api: api, credentialStore: creds, baseURL: baseURL)
        self.checkoutRepo = CheckoutRepositoryImpl(api: api, baseURL: baseURL)
        self.paymentMethodRepo = PaymentMethodRepositoryImpl(api: api, baseURL: baseURL)
        self.selectedPaymentMethodRepo = SelectedPaymentMethodRepositoryImpl(api: api, baseURL: baseURL)
    }
    
    private func ensureToken() async throws -> String {
        if let token = token { return token }
        let response = try await authRepo.authenticate()
        self.token = response.token
        return response.token
    }
    
    public func startCheckout(order: Order, configuration: Configuration) async throws -> CheckoutSessionResponse {
        let token = try await ensureToken()
        let request = CheckoutRequest(order: order, configuration: configuration)
        return try await checkoutRepo.createSession(request: request, token: token)
    }
    
    public func getPaymentMethods(sessionId: String) async throws -> [PaymentMethod] {
        let token = try await ensureToken()
        return try await paymentMethodRepo.fetchMethods(sessionId: sessionId, token: token)
    }
    
    public func initiatePayment(methodId: String, sessionId: String) async throws -> URL? {
        let token = try await ensureToken()
        let req = PaymentInitiationRequest(paymentMethodId: methodId, sessionId: sessionId)
        let urlString = try await selectedPaymentMethodRepo.initiatePayment(paymentInitiationRequest: req, token: token)
        return URL(string: urlString)
    }
}

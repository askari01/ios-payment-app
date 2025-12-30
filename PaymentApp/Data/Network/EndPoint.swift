//
//  EndPoint.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct Endpoint {
    let url: URL
    let method: HTTPMethod
    let headers: [String: String]
    let body: Data?
}

enum APIConstants {
    static let baseURL = "https://testgateway.altapaysecure.com/"
    static let timeout: TimeInterval = 30
    static let version = "v1"
    static let urlPath = {
        baseURL+"checkout/\(version)/api"
    }
}

enum AuthEndpoints {
    static func authenticate(
        authorization: String,
    ) -> Endpoint {
        Endpoint(
            url: URL(string:
                        APIConstants.urlPath()+"/authenticate")!,
            method: .post,
            headers: [
                "Authorization": authorization
            ],
            body: nil
        )
    }
}

enum CheckoutEndpoints {

    static func createSession(
        body: CheckoutRequest,
        authorization: String,
    ) -> Endpoint {

        Endpoint(
            url: URL(string: APIConstants.urlPath()+"/session")!,
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": authorization
            ],
            body: try? JSONEncoder().encode(body)
        )
    }
}

enum PaymentMethodEndpoints {

    static func list(
        sessionId: String,
        token: String,
    ) -> Endpoint {

        Endpoint(
            url: URL(
                string:
                    APIConstants.urlPath()+"/session/\(sessionId)/payment-methods"
            )!,
            method: .get,
            headers: [
                "Authorization": "Bearer \(token)"
            ],
            body: nil
        )
    }
}

enum SelectedPaymentMethodEndpoints {

    static func initiatePayment(
        body: PaymentInitiationRequest,
        token: String,
    ) -> Endpoint {

        Endpoint(
            url: URL(
                string:
                    APIConstants.urlPath()+"/payment"
            )!,
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ],
            body: try? JSONEncoder().encode(body)
        )
    }
}

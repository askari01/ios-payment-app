//
//  ContentView.swift
//  DemoApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

import SwiftUI
import AltaPaySDK

struct ContentView: View {
    
    @State private var session: PaymentSession?
    @State private var paymentMethods: [PaymentMethod] = []
    @State private var checkoutSession: CheckoutSession?
    @State private var redirectURL: URL?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            List {
                if isLoading {
                    ProgressView("Loading payment methods...")
                } else if let error = errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else {
                    ForEach(paymentMethods) { method in
                        PaymentMethodRow(method: method) {
                            handlePaymentMethodSelection(method)
                        }
                    }
                }
            }
            .navigationTitle("Payment Methods")
            .task {
                await initializeAndLoad()
            }
            .sheet(item: Binding(
                get: { redirectURL.map { PaymentRedirect(url: $0) } },
                set: { if $0 == nil { redirectURL = nil } }
            )) { redirect in
                PaymentWebView(
                    url: redirect.url,
                    onSuccess: { url in
                        print("Payment successful: \(url)")
                        redirectURL = nil
                    },
                    onFailure: { url in
                        print("Payment failed: \(url)")
                        redirectURL = nil
                    }
                )
            }
        }
    }
    
    private func initializeAndLoad() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Create payment session
            let paymentSession = try PaymentSession()
            self.session = paymentSession
            
            // Authenticate
            let token = try await paymentSession.authenticate()
            print("Authenticated with token: \(token)")
            
            // Create checkout session with test order
            let order = Order(
                orderId: "DemoApp-\(UUID().uuidString)",
                amount: Amount(value: 2.0, currency: "DKK"),
                orderLines: [
                    OrderLine(
                        itemId: "123981239",
                        description: "Chaos Emerald",
                        quantity: 1,
                        unitPrice: 1
                    ),
                    OrderLine(
                        itemId: "123981240",
                        description: "Delivery",
                        quantity: 1,
                        unitPrice: 1
                    )
                ],
                customer: Customer(
                    firstName: "John",
                    lastName: "Doe",
                    email: "test@example.com",
                    billingAddress: Address(
                        street: "Nygaardsvej 42",
                        city: "Copenhagen",
                        country: "DK",
                        zipCode: "1040"
                    ),
                    shippingAddress: Address(
                        street: "Nygaardsvej 42",
                        city: "Copenhagen",
                        country: "DK",
                        zipCode: "1040"
                    )
                )
            )
            
            let config = PaymentConfiguration(
                paymentType: "PAYMENT",
                paymentDisplayType: "REDIRECT",
                bodyFormat: "JSON",
                autoCapture: false,
                country: "DK",
                language: "da"
            )
            
            let session = try await paymentSession.createCheckoutSession(
                order: order,
                configuration: config
            )
            self.checkoutSession = session
            print("Checkout session created: \(session.sessionId)")
            
            // Fetch payment methods
            let methods = try await paymentSession.fetchPaymentMethods(
                sessionId: session.sessionId
            )
            self.paymentMethods = methods
            print("Loaded \(methods.count) payment methods")
            
        } catch {
            errorMessage = error.localizedDescription
            print("Error: \(error)")
        }
        
        isLoading = false
    }
    
    private func handlePaymentMethodSelection(_ method: PaymentMethod) {
        guard let session = session,
              let checkoutSession = checkoutSession else {
            errorMessage = "Session not initialized"
            return
        }
        
        Task {
            do {
                let url = try await session.initiatePayment(
                    methodId: method.id,
                    sessionId: checkoutSession.sessionId
                )
                redirectURL = url
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct PaymentRedirect: Identifiable {
    let id = UUID()
    let url: URL
}

struct PaymentMethodRow: View {
    let method: PaymentMethod
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if let logo = method.logoUrl,
                   let url = URL(string: logo),
                   !logo.contains("null") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 40, height: 40)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(method.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(method.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(method.type)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}

# PaymentSDK Usage Guide

## How Developers Will Use This Package

### Step-by-Step Integration

#### 1. Add Package Dependency

**Via Xcode:**
- File → Add Packages...
- Enter package URL or local path
- Select version

**Via Package.swift:**
```swift
dependencies: [
    .package(path: "./PaymentSDK")
]
```

#### 2. Import the SDK

```swift
import PaymentSDK
```

#### 3. Initialize Payment Client

```swift
// In your App struct or ViewModel
let client = PaymentClient(
    username: "your_username",
    password: "your_password",
    baseURL: URL(string: "https://gateway.altapaysecure.com/")!
)
```

**Best Practice:** Load credentials from environment variables or Keychain:
```swift
let username = ProcessInfo.processInfo.environment["PAYMENT_USERNAME"] ?? ""
let password = ProcessInfo.processInfo.environment["PAYMENT_PASSWORD"] ?? ""
```

#### 4. Create Checkout Session

```swift
let order = Order(
    orderId: "ORDER-\(UUID().uuidString)",
    amount: Amount(value: 100.0, currency: "USD"),
    orderLines: [
        OrderLine(
            itemId: "ITEM-1",
            description: "Product Name",
            quantity: 1,
            unitPrice: 100.0
        )
    ],
    customer: Customer(
        firstName: "John",
        lastName: "Doe",
        email: "john@example.com",
        billingAddress: Address(
            street: "123 Main St",
            city: "New York",
            country: "US",
            zipCode: "10001"
        ),
        shippingAddress: Address(
            street: "123 Main St",
            city: "New York",
            country: "US",
            zipCode: "10001"
        )
    ),
    transactionInfo: [:]
)

let config = Configuration(
    paymentType: "PAYMENT",
    paymentDisplayType: "REDIRECT",
    bodyFormat: "JSON",
    autoCapture: false,
    country: "US",
    language: "en"
)

do {
    let session = try await client.startCheckout(order: order, configuration: config)
    // Store session.sessionId for later use
} catch {
    // Handle error
}
```

#### 5. Fetch Payment Methods

```swift
do {
    let methods = try await client.getPaymentMethods(sessionId: sessionId)
    // Display methods to user
} catch {
    // Handle error
}
```

#### 6. Initiate Payment

```swift
do {
    let redirectURL = try await client.initiatePayment(
        methodId: selectedMethod.id,
        sessionId: sessionId
    )
    // Show PaymentWebView with redirectURL
} catch {
    // Handle error
}
```

#### 7. Display Payment WebView

```swift
import SwiftUI

struct PaymentView: View {
    let redirectURL: URL
    @State private var showWebView = true
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        PaymentWebView(url: redirectURL) { result in
            showWebView = false
            
            switch result {
            case .success(let url):
                // Payment successful
                print("Payment successful: \(url)")
                dismiss()
                // Navigate to success screen
            case .failure(let error):
                // Payment failed
                print("Payment failed: \(error.localizedDescription)")
                // Show error alert
            case .cancelled:
                // User cancelled
                print("Payment cancelled")
                dismiss()
            }
        }
    }
}
```

### Complete Example: SwiftUI View

```swift
import SwiftUI
import PaymentSDK

@Observable
class PaymentViewModel {
    private let client: PaymentClient
    var methods: [PaymentMethod] = []
    var isLoading = false
    var error: String?
    var sessionId: String?
    var redirectURL: URL?
    
    init(client: PaymentClient) {
        self.client = client
    }
    
    func startCheckout() async {
        isLoading = true
        defer { isLoading = false }
        
        let order = Order(...) // Your order
        let config = Configuration(...) // Your config
        
        do {
            let session = try await client.startCheckout(order: order, configuration: config)
            sessionId = session.sessionId
        } catch {
            error = error.localizedDescription
        }
    }
    
    func loadPaymentMethods() async {
        guard let sessionId = sessionId else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            methods = try await client.getPaymentMethods(sessionId: sessionId)
        } catch {
            error = error.localizedDescription
        }
    }
    
    func selectMethod(_ method: PaymentMethod) async {
        guard let sessionId = sessionId else { return }
        
        do {
            redirectURL = try await client.initiatePayment(
                methodId: method.id,
                sessionId: sessionId
            )
        } catch {
            error = error.localizedDescription
        }
    }
}

struct PaymentMethodsView: View {
    @State private var viewModel: PaymentViewModel
    @State private var showPayment = false
    
    var body: some View {
        List(viewModel.methods) { method in
            Button {
                Task {
                    await viewModel.selectMethod(method)
                    if viewModel.redirectURL != nil {
                        showPayment = true
                    }
                }
            } label: {
                PaymentMethodRow(method: method)
            }
        }
        .sheet(isPresented: $showPayment) {
            if let url = viewModel.redirectURL {
                PaymentWebView(url: url) { result in
                    showPayment = false
                    // Handle result
                }
            }
        }
        .task {
            await viewModel.startCheckout()
            await viewModel.loadPaymentMethods()
        }
    }
}
```

### Error Handling Patterns

#### Pattern 1: Do-Catch with User Feedback

```swift
Task {
    do {
        let session = try await client.startCheckout(order: order, configuration: config)
        // Success
    } catch let error as PaymentSDKError {
        switch error {
        case .authenticationFailed(let message):
            showAlert("Authentication failed", message)
        case .networkError(let underlyingError):
            showAlert("Network error", underlyingError.localizedDescription)
        default:
            showAlert("Error", error.localizedDescription ?? "Unknown error")
        }
    } catch {
        showAlert("Error", error.localizedDescription)
    }
}
```

#### Pattern 2: Result-Based Handling

```swift
func startCheckout() async -> Result<CheckoutSessionResponse, Error> {
    do {
        let session = try await client.startCheckout(order: order, configuration: config)
        return .success(session)
    } catch {
        return .failure(error)
    }
}
```

### Best Practices

1. **Credential Management**
   - Never hardcode credentials
   - Use Keychain for production
   - Use environment variables for development

2. **Error Handling**
   - Always handle errors
   - Show user-friendly messages
   - Log errors for debugging

3. **Loading States**
   - Show loading indicators during async operations
   - Disable UI during loading
   - Handle cancellation

4. **Session Management**
   - Store session ID securely
   - Handle session expiration
   - Retry failed operations when appropriate

5. **Payment Flow**
   - Guide users through the flow
   - Handle all payment result cases
   - Provide clear feedback

### Common Use Cases

#### Use Case 1: Simple Payment Flow

```swift
// 1. Create client
let client = PaymentClient(...)

// 2. Create session
let session = try await client.startCheckout(...)

// 3. Get methods
let methods = try await client.getPaymentMethods(sessionId: session.sessionId)

// 4. Initiate payment
let url = try await client.initiatePayment(methodId: method.id, sessionId: session.sessionId)

// 5. Show WebView
PaymentWebView(url: url) { result in
    // Handle result
}
```

#### Use Case 2: Payment with Retry

```swift
func initiatePaymentWithRetry(methodId: String, sessionId: String, maxRetries: Int = 3) async throws -> URL {
    var lastError: Error?
    
    for attempt in 1...maxRetries {
        do {
            return try await client.initiatePayment(methodId: methodId, sessionId: sessionId)
        } catch {
            lastError = error
            if attempt < maxRetries {
                try await Task.sleep(nanoseconds: UInt64(attempt) * 1_000_000_000) // Exponential backoff
            }
        }
    }
    
    throw lastError ?? PaymentSDKError.paymentInitiationFailed("Failed after \(maxRetries) attempts")
}
```

### Testing

#### Unit Testing

```swift
import XCTest
@testable import PaymentSDK

class PaymentClientTests: XCTestCase {
    func testStartCheckout() async throws {
        let client = PaymentClient(
            username: "test",
            password: "test",
            baseURL: URL(string: "https://test.example.com/")!
        )
        
        let order = Order(...)
        let config = Configuration(...)
        
        let session = try await client.startCheckout(order: order, configuration: config)
        XCTAssertNotNil(session.sessionId)
    }
}
```

### Troubleshooting

#### Issue: Authentication Failed
- Check credentials are correct
- Verify base URL is correct
- Check network connectivity

#### Issue: No Payment Methods
- Verify session ID is valid
- Check session hasn't expired
- Verify configuration is correct

#### Issue: Payment Initiation Fails
- Check method ID is valid
- Verify session is still active
- Check network connectivity

#### Issue: WebView Doesn't Load
- Verify URL is valid
- Check network permissions
- Verify HTTPS is enabled

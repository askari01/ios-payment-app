# AltaPay SDK for iOS

A Swift SDK for integrating AltaPay payment processing into your iOS applications.

## Requirements

- iOS 15.0 or later
- Swift 5.9 or later
- Xcode 15.0 or later
- Valid AltaPay API credentials (username and password)
- Network access (HTTPS)

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/altapay-sdk-ios.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Packages...
2. Enter the repository URL
3. Select the version or branch

### Manual Installation

1. Clone this repository
2. Add `AltaPaySDK` to your Xcode project
3. Link the framework in your target's "Frameworks, Libraries, and Embedded Content"

## Quick Start

### 1. Initialize the SDK

In your app's initialization (e.g., `App` struct or `AppDelegate`):

```swift
import AltaPaySDK

@main
struct MyApp: App {
    init() {
        do {
            try AltaPaySDK.initialize(
                baseURL: "https://testgateway.altapaysecure.com/",
                username: "your_username",
                password: "your_password"
            )
        } catch {
            print("Failed to initialize SDK: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 2. Create a Payment Session

```swift
let session = try PaymentSession()
```

### 3. Authenticate

```swift
let token = try await session.authenticate()
```

### 4. Create a Checkout Session

```swift
let order = Order(
    orderId: "ORDER-123",
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
    )
)

let config = PaymentConfiguration(
    paymentType: "PAYMENT",
    paymentDisplayType: "REDIRECT",
    country: "US",
    language: "en"
)

let checkoutSession = try await session.createCheckoutSession(
    order: order,
    configuration: config
)
```

### 5. Fetch Payment Methods

```swift
let methods = try await session.fetchPaymentMethods(
    sessionId: checkoutSession.sessionId
)
```

### 6. Initiate Payment

```swift
let redirectURL = try await session.initiatePayment(
    methodId: selectedMethod.id,
    sessionId: checkoutSession.sessionId
)
```

### 7. Display Payment WebView

```swift
import SwiftUI
import AltaPaySDK

struct PaymentView: View {
    let redirectURL: URL
    
    var body: some View {
        PaymentWebView(
            url: redirectURL,
            onSuccess: { url in
                print("Payment successful!")
            },
            onFailure: { url in
                print("Payment failed!")
            }
        )
    }
}
```

## Complete Example

See the `DemoApp` directory for a complete working example.

## API Reference

### AltaPaySDK

Main SDK entry point.

#### Methods

- `initialize(baseURL:username:password:version:)` - Initialize the SDK with credentials
- `shared` - Shared singleton instance
- `isInitialized` - Check if SDK has been initialized

### PaymentSession

Main interface for payment operations.

#### Methods

- `authenticate() async throws -> String` - Authenticate and get access token
- `createCheckoutSession(order:configuration:) async throws -> CheckoutSession` - Create checkout session
- `fetchPaymentMethods(sessionId:) async throws -> [PaymentMethod]` - Get available payment methods
- `initiatePayment(methodId:sessionId:) async throws -> URL` - Initiate payment and get redirect URL

### Models

- `Order` - Order details
- `Amount` - Monetary amount
- `OrderLine` - Order line item
- `Customer` - Customer information
- `Address` - Address information
- `PaymentMethod` - Payment method information
- `PaymentConfiguration` - Payment configuration
- `CheckoutSession` - Checkout session response

### PaymentWebView

SwiftUI view for displaying payment redirects.

#### Parameters

- `url: URL` - Payment redirect URL
- `onSuccess: ((URL) -> Void)?` - Callback when payment succeeds
- `onFailure: ((URL) -> Void)?` - Callback when payment fails
- `onRedirect: ((URL) -> Void)?` - Callback for any redirect

## Error Handling

The SDK uses `AltaPayError` enum for error handling:

```swift
do {
    let session = try PaymentSession()
    // Use session...
} catch let error as AltaPayError {
    switch error {
    case .notInitialized:
        // SDK not initialized
    case .authenticationFailed(let message):
        // Authentication failed
    case .networkError(let underlyingError):
        // Network error
    // ... other cases
    }
} catch {
    // Other errors
}
```

## Error Types

- `notInitialized` - SDK has not been initialized
- `invalidConfiguration(String)` - Invalid configuration provided
- `authenticationFailed(String)` - Authentication failed
- `networkError(Error)` - Network error occurred
- `invalidResponse` - Invalid response from server
- `paymentInitiationFailed(String)` - Payment initiation failed
- `sessionCreationFailed(String)` - Session creation failed
- `paymentMethodsFetchFailed(String)` - Failed to fetch payment methods
- `invalidURL(String)` - Invalid URL

## Security Considerations

1. **Credentials**: Never hardcode credentials in your app. Use secure storage (Keychain) or environment variables.
2. **HTTPS**: The SDK enforces HTTPS connections.
3. **Token Storage**: Access tokens are stored in memory and not persisted.

## Testing

The SDK includes unit tests. Run tests using:

```bash
swift test
```

## Demo App

A complete demo app is included in the `DemoApp` directory. To run it:

1. Update credentials in `DemoApp/App/DemoApp.swift`
2. Build and run the demo app target

## License

[Add your license here]

## Support

For issues and questions, please open an issue on GitHub or contact support.

## Changelog

### 1.0.0
- Initial release
- Payment session management
- Payment method selection
- Payment initiation
- WebView integration

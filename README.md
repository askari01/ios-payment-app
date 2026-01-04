# AltaPay - iOS SDK (Demo Project & Library)

This repository contains a reusable **AltaPay Merchant iOS SDK** along with a **demo iOS application** that demonstrates how to integrate and execute AltaPay payment flows using WebView.

## Merchant API flow

![Altapay-MobileApp-Setup](https://github.com/AltaPay/android-payment-app/blob/main/docs/Altapay-MobileApp-Setup.png)

## Repository Overview

This project is structured as a **sample iOS project**:

1. **AltaPay Merchant SDK (Library Module)**
   - Clean, reusable SDK for creating AltaPay payment requests
   - Swift + async/await based
   - No iOS `Context` dependency

2. **Demo iOS Application**
   - Shows real-world SDK usage
   - WebView-based payment flow
   - Progress dialog handling

## Prerequisites

- Xcode 16 or newer
- Swift 5
- iOS 18
- Active Internet connection

## How to use

- Clone the repository
    ```bash
    git clone https://github.com/askari01/ios-payment-app.git
    cd PaymentApp
    ```

- Open the project in **Xcode**:

    ```
    File > Open > select PaymentApp
    ```

    ### How to Run the Demo App

    1. Select the **app** run configuration
    2. Connect an iOS device or start a simulator
    3. Click **Run**

    ### Demo App Configuration

    Update AltaPay credentials in `ContentView.swift`: (for app preview support)
    Update AltaPay credentials in `PaymentApp.swift`: (for app simulator/real device)

    ```Swift
    struct AppCredentialStore: CredentialStore {
        var username: String { "xxxxxxxxxxxxxx" }
        var password: String { "xxxxxxxxxxxxxx" }
    }
    ```

## Integrating SDK into your app

### 1. Add SDK Module

1. Copy `PaymentApp` into your project root.

### 2. Initialize Payment Client

```Swift
struct AppCredentialStore: CredentialStore {
        var username: String { "xxxxxxxxxxxxx" }
        var password: String { "xxxxxxxxxxxxx" }
    }
```

### 3. Prepare Payment Parameters

1. Create a Model for `CheckoutRequest` which includes data regarding `Order` and configuration (payment type, country and language)

### 4. Request Session Parameters

1. Reqest for session using Model for `CheckoutRequest`

```Swift
await checkoutRepo.createSession(
                request: CheckoutRequest,
                token: token
            )
```

### 5. Execute Payment Request

create model for `PaymentInitiationRequest` using desired payment method from the list

```Swift
await repo.initiatePayment(
                paymentInitiationRequest: paymentInitiationRequest,
                token: token,
            )
```

### 7. WebView

payment status needs to be handled via webview status


## Error Handling

- Network errors
- Authentication failures

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

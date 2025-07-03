# 📱 Netomi Mobile Chat SDK Sample App (iOS)

This repository contains a working example of how to integrate and customize the [Netomi Chat SDK](https://www.netomi.com) in an iOS app using UIKit.

It showcases:

- ✅ SDK initialization with `botRefId`
- ✅ JWT-based chat launching
- ✅ Runtime UI customization (header, footer, bubbles, etc.)
- ✅ FCM token registration

---

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
  - [Initialize SDK](#initialize-sdk)
  - [Launch Chat](#launch-chat)
  - [Pass JWT Token](#pass-jwt-token)
  - [Send Custom Parameters](#send-custom-parameters)
  - [Apply UI Customization](#apply-ui-customization)
  - [Set FCM Token](#set-fcm-token)
- [Support](#support)
- [License](#license)

---

## 📖 Overview

The **Netomi iOS Chat SDK** allows you to embed conversational AI into your app. It supports:

- Rich media responses
- File uploads and forms
- Live agent handoff
- Firebase push notifications
- Flexible UI styling (via code or Netomi dashboard)

This sample demonstrates how to integrate, customize, and interact with the SDK in a real UIKit-based app.

---

## ✅ Prerequisites

- Xcode 13 or later
- iOS 15 or later
- CocoaPods or Swift Package Manager
- `botRefId` and environment (`.USProd`, `.INProd`, etc.) from Netomi

---

## 📦 Installation

### Option 1: CocoaPods

```ruby
pod 'NetomiChatSDK'
```

```bash
pod install
```

Then open the `.xcworkspace` file.

---

### Option 2: Swift Package Manager (SPM)

1. Open Xcode → Project → **Package Dependencies**
2. Add:

```bash
https://github.com/msgai/netomi-chat-ios.git
```

3. Choose a version tag (or `main`).

---

## Quick Start

### ✅ Initialize SDK

```swift
NetomiChat.shared.initialize(
    botRefId: "YOUR_BOT_REF_ID",
    environment: .USProd
)
```

> Replace `YOUR_BOT_REF_ID` and choose the environment: `.USProd`, `.SGProd`, `.EUProd`, `.QA`, `.QAInternal`, `.Development`
>
> 🔹 Most visual styling can be configured via the Netomi Dashboard.  
>
> 🔹 If you'd like to customize it locally in code, see [Apply UI Customization](#apply-ui-customization)


---

### 🚀 Launch Chat

```swift
NetomiChat.shared.launch(jwt: nil) { error in
    // Handle launch error if any
}
```

Or with a search query:

```swift
NetomiChat.shared.launchWithQuery("search here", jwt: nil) { error in
    // Optional error handling
}
```

---

### 🔐 Pass JWT Token (optional)

```swift
let jwt = "your-jwt-token"
NetomiChat.shared.launch(jwt: jwt)
```

---

### 🧩 Send Custom Parameters

You can pass custom parameters to personalize the chat experience or pass session-specific metadata to the AI backend.

#### 🔹 To send a single key-value parameter

```swift
// Example: Indicate that the current user is a premium member
NetomiChat.shared.sendCustomParameter(name: "user_role", value: "premium_user")
```

#### 🔹 To set multiple custom parameters at once

```swift
// Example: Pass user profile info during initialization
let userAttributes: [String: String] = [
  "user_id": "12345",                // Unique ID of the user
  "user_name": "John Doe",           // Optional full name
  "membership_level": "gold",        // Tier of user (e.g., gold, silver)
  "app_version": "7.2.0"             // Current app version for debugging or targeting
]

NetomiChat.shared.setCustomParameter(userAttributes)
```

---

### 🧾 Pass Custom API Headers (Optional)

> Send custom HTTP headers with each SDK API request — useful for:
>
> - Authentication tokens
> - Versioning
> - Experiment targeting
> - Localization context

```swift
let customHeaders: [String: String] = [
  "X-App-Version": "7.2.0",                       // Current app version
  "X-Device-ID": "device-98765",                  // Unique device identifier
  "X-Platform": "iOS",                            // OS platform info
  "X-User-Type": "beta_tester",                   // User group/segment
  "X-Experiment-Variant": "A",                    // A/B test group
  "X-Locale": Locale.current.identifier           // e.g., "en_US"
]

NetomiChat.shared.updateApiHeaderConfiguration(headers: customHeaders)
```

> ⚠️ These headers are automatically sent with each SDK API call.
Avoid including any sensitive data like passwords or secrets.

---

### 🎨 Apply UI Customization (Optional)

```swift
/// 🧩 Header Configuration: App bar at the top of the chat
var header = NCWHeaderConfiguration()
header.backgroundColor = .systemBlue                     // Set header background color
header.isGradientAppied = true                          // Enable gradient effect
header.isBackPressPopupEnabed = true                    // Show confirmation popup on back
header.navigationIcon = UIImage(named: "logo")          // Optional: Add a custom logo icon
NetomiChat.shared.updateHeaderConfiguration(config: header)

/// 🧩 Footer Configuration: Input area at the bottom
var footer = NCWFooterConfiguration()
footer.backgroundColor = .white                          // Background color of input footer
footer.inputBoxTextColor = .darkGray                    // Text color for message input
footer.isFooterHidden = false                           // Show/hide the footer
footer.isNetomiBrandingEnabled = true                   // Show "Powered by Netomi" branding
NetomiChat.shared.updateFooterConfiguration(config: footer)

/// 🧩 Bot Message Bubble Styling
var botConfig = NCWBotConfiguration()
botConfig.backgroundColor = .lightGray                   // Bot message background
botConfig.textColor = .black                             // Bot message text color
botConfig.quickReplyBackgroundColor = .systemGray4       // Quick reply pill color
botConfig.isFeedbackEnabled = true                       // Enable thumbs up/down feedback
NetomiChat.shared.updateBotConfiguration(config: botConfig)


/// 🧩 User Message Bubble Styling
var userConfig = NCWUserConfiguration()
userConfig.backgroundColor = .darkGray                   // User message bubble color
userConfig.textColor = .white                            // Text color in user bubbles
userConfig.retryColor = .red                             // Retry button color (on failure)
userConfig.quickReplyBackgroundColor = .gray             // Optional quick reply pill style
NetomiChat.shared.updateUserConfiguration(config: userConfig)


/// 🧩 Chat Bubble Settings (general style)
var bubbleConfig = NCWBubbleConfiguration()
bubbleConfig.borderRadius = 16                           // Rounded corners for messages
bubbleConfig.timeStampColor = .gray                      // Timestamp text color
NetomiChat.shared.updateBubbleConfiguration(config: bubbleConfig)


/// 🧩 Entire Chat Window Background
var windowConfig = NCWChatWindowConfiguration()
windowConfig.chatWindowBackgroundColor = .white          // Background behind all chat bubbles
NetomiChat.shared.updateChatWindowConfiguration(config: windowConfig)

/// 🧩 Miscellaneous Title and Info Section Styling
var otherConfig = NCWOtherConfiguration()
otherConfig.backgroundColor = .white                     // Info section background
otherConfig.titleColor = .black                          // Title text
otherConfig.descriptionColor = .darkGray                 // Description/subtext
NetomiChat.shared.updateOtherConfiguration(config: otherConfig)

```

---

### 🔔 Set FCM Token

```swift
NetomiChat.shared.setFCMToken("your-fcm-token")
```

---

## 🛠 Support

For SDK issues or integration help:

- 📘 [Netomi Documentation](https://www.netomi.com)
- 📩 <support@netomi.com>

---

## 📄 License

```
© 2025 Netomi. All rights reserved.
This sample app is for demonstration purposes only.
The Netomi Mobile Chat SDK may include its own license terms.
Refer to Netomi's official documentation for legal details.
```

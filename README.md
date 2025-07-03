# Netomi Mobile Chat SDK Sample App (iOS)

This repository contains a sample iOS application showcasing how to integrate and use the Netomi Mobile Chat SDK for conversational AI. It illustrates basic SDK initialization, chat launching, and UI customization options.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Setup & Installation](#setup--installation)
    - [Clone or Download the Sample](#clone-or-download-the-sample)
    - [Configure the SDK via CocoaPods or SPM](#configure-the-sdk-via-cocoapods-or-spm)
- [Build & Run](#build--run)
- [Sample Code Walkthrough](#sample-code-walkthrough)
    - [Initialization](#initialization)
    - [Launching the Chat](#launching-the-chat)
    - [Sending Custom Parameters](#sending-custom-parameters)
    - [Customization Examples](#customization-examples)
- [Pass FCM Token](#pass-fcm-token)
- [License & Legal](#license--legal)
- [Support](#support)

## Overview

The Netomi Mobile Chat SDK makes it easy to embed conversational AI into your iOS application. It supports:
- Rich media responses
- Forms and file attachments
- Live agent handoff
- Customizable look and feel

This sample app demonstrates the core integration steps and includes code examples for customizing various aspects of the chat UI.

---

## Prerequisites

- iOS 15 or later
- Xcode 13+
- UIKit or SwiftUI (both supported by the SDK)
- CocoaPods or Swift Package Manager
- Your Bot Credentials from Netomi (`botRefId`, `env`)

---

## Installation

### 1️⃣ CocoaPods

1. Add this to your `Podfile`:

   ```ruby
   pod 'NetomiChatSDK', '{{VERSION}}'
   ```

2. Run:

   ```bash
   pod install
   ```

3. Open `.xcworkspace` in Xcode.

---

### 2️⃣ Swift Package Manager (SPM)

1. Go to **Xcode > Project > Package Dependencies**
2. Add:

   ```
   https://github.com/msgai/netomi-chat-ios.git
   ```

3. Select tag or branch: `{{VERSION}}`

4. ✅ Required third-party dependencies (must be added manually via SPM):
   - AWS IoT Core:
     ```
     https://github.com/aws-amplify/aws-sdk-ios-spm.git
     ```
     - Select `AWSCore` and `AWSIoT`

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
---

### 🚀 Launch Chat

```swift
NetomiChat.shared.launch(jwt: nil) { error in
    // Handle launch error if any
}

OR

NetomiChat.shared.launchWithQuery("your_search_query", jwt: nil) { errorData in
    // Handle launch error if any
}
```

---

### 🧩 Send Custom Parameters

```swift
NetomiChat.shared.sendCustomParameter(name: "department", value: "marketing")

OR

/// To set/reset custom parameters for attibutes
var dict: [String: String] = [:]
dict["department"] = "marketing"
dict["userID"] = "USR-998877"
NetomiChat.shared.setCustomParameter(dict)
```

---

### 🧩 Send Header Parameters in the APIs

```swift
var headers: [String: String] = [:]
headers["platform"] = "iOS"
headers["authType"] = "JWT"
// and so on....
NetomiChat.shared.updateApiHeaderConfiguration(headers: headers)
```

---

### 🔔 Set FCM Token (Push Notifications)

```swift
NetomiChat.shared.setFCMToken("your-fcm-token")
```

---

## 🎨 Customize UI

### 🎨 Header Customization

```swift
var config: NCWHeaderConfiguration = NCWHeaderConfiguration()
config.backgroundColor = .red
config.isGradientAppied = true
config.isBackPressPopupEnabed = true
config.navigationIcon = UIImage.logo
// and so on....
NetomiChat.shared.updateHeaderConfiguration(config: config)
```

### 🎨 Footer Customization

```swift
var config: NCWFooterConfiguration = NCWFooterConfiguration()
config.backgroundColor = .red
config.inputBoxTextColor = .black
config.isFooterHidden = false
config.isNetomiBrandingEnabled = true
// and so on....
NetomiChat.shared.updateFooterConfiguration(config: config)
```

### 🎨 Bot Customization

```swift
var config: NCWBotConfiguration = NCWBotConfiguration()
config.backgroundColor = .lightGray
config.isFeedbackEnabled = true
config.quickReplyBackgroundColor = .lightGray
config.textColor = .black
// and so on....
NetomiChat.shared.updateBotConfiguration(config: config)
```

### 🎨 User Customization

```swift
var config: NCWUserConfiguration = NCWUserConfiguration()
config.backgroundColor = .darkGray
config.retryColor = .red
config.quickReplyBackgroundColor = .darkGray
config.textColor = .white
// and so on....
NetomiChat.shared.updateUserConfiguration(config: config)
```

### 🎨 Bubble Customization

```swift
var config: NCWBubbleConfiguration = NCWBubbleConfiguration()
config.borderRadius = 20
config.timeStampColor = .gray
NetomiChat.shared.updateBubbleConfiguration(config: config)
```

### 🎨 Chat Window Customization

```swift
var config: NCWChatWindowConfiguration = NCWChatWindowConfiguration()
config.chatWindowBackgroundColor = .white
NetomiChat.shared.updateChatWindowConfiguration(config: config)
```

### 🎨 Other Customization

```swift
var config: NCWOtherConfiguration = NCWOtherConfiguration()
config.backgroundColor = .white
config.titleColor = .black
config.descriptionColor = .black
// and so on....
NetomiChat.shared.updateOtherConfiguration(config: config)
```

---

## Support

- 📘 Docs: [netomi.com](https://www.netomi.com)
- 📩 Contact: support@netomi.com

---

## License

```
© 2025 Netomi. All rights reserved. This sample app is for demonstration purposes only. The Netomi Mobile Chat SDK may include its own license terms. Review the LICENSE file in this repository (if available) and refer to official Netomi documentation for detailed legal information.
```

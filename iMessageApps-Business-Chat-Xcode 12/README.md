# Package Delivery: A simple Business Chat Example

This sample illustrates how you can go about building an app extension that interacts with Business Chat. It allows your business to interact with your customer via an iMessage application.

## Overview

This sample code highlights the use of the [`MSMessage`](https://developer.apple.com/documentation/messages/msmessage) URL property as a way to receive additional data from your Customer Service Provider server. This data can be used to drive the state of your application or to provide supplementary information needed by your model. In this specific example, we use the data provided in the URL to initialize our Package model object which is returned with a selected destination when the user replies to the message.

## Getting Started

- Install the PackageDeliveryMessagesExtension on your device.
- Replace all `<team-identifier>` placeholders in the sample JSON (BCSandbox_payload.json) with your team-identifier listed in your iOS developer account.
- Build for your connected test device
- Leverage your Messaging console to send the proper payload to call this iMessage app

## Requirements

### Build

Xcode 12.0 or later; iOS 14.0 SDK or later.

### Runtime

iOS 14.0 or later.

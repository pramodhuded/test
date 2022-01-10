/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The root view controller shown by the Messages app.
*/

import UIKit
import Messages

protocol PackageDeliveryMessageAppDelegate: class {
    func sendReplyMessage(with package: Package)
    func requestExpandedState()
}

class MessagesViewController: MSMessagesAppViewController {
    
    // MARK: Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        updatePresentation(for: conversation)
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.didTransition(to: presentationStyle)
        
        guard let conversation = activeConversation else {
            fatalError("Expected an active converstation")
        }
        
        updatePresentation(for: conversation)
    }
    
    func updatePresentation(for conversation: MSConversation) {
        /* The selected message URL property provides a way to receive additional data from your Customer Service Provider server.
         This data can be used to drive the state of your application or to provide supplementary information needed by your application */
        var package: Package?
        if let url = conversation.selectedMessage?.url {
            do {
                package = try Package(url: url)
            } catch {
                print("Failed to create package: \(error)")
            }
        }
        
        if presentationStyle == .transcript {
            presentTranscriptView(for: package)
        } else {
            presentViewController(for: package, with: presentationStyle)
        }
    }
    
    // MARK: View Controller Presentation
    
    private func presentViewController(for package: Package?, with presentationStyle: MSMessagesAppPresentationStyle) {
        var viewController: UIViewController
        removeAllChildViewControllers()
        
        if presentationStyle == .expanded, let package = package {
            viewController = PackageDeliveryViewController(package: package, delegate: self)
        } else {
            let notAvailable = NotAvailableViewController(delegate: self)
            notAvailable.canExpand = package != nil
            viewController = notAvailable
        }
        
        addChild(viewController)
        viewController.view.frame = view.bounds
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            viewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            viewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    private func removeAllChildViewControllers() {
        children.forEach { (child) in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    // MARK: Live Bubble Presentation
    
    private func presentTranscriptView(for package: Package?) {
        let bubbleView = PackageDeliveryBubbleView(package: package)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bubbleViewTapped(_:))))
        
        view.addSubview(bubbleView)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: view.topAnchor),
            bubbleView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bubbleView.rightAnchor.constraint(equalTo: view.rightAnchor),
            bubbleView.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor)
            ])
    }
    
    override func contentSizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 210)
    }
    
    // MARK: User Actions
    
    @objc
    func bubbleViewTapped(_ sender: UITapGestureRecognizer) {
        if let packageBubbleView = sender.view as? PackageDeliveryBubbleView, packageBubbleView.package != nil {
            requestPresentationStyle(.expanded)
        }
    }
}

/**
 Extends `MessagesViewController` to conform to the `PackageDeliveryMessageAppDelegate`
 protocol.
 */
extension MessagesViewController:PackageDeliveryMessageAppDelegate {
    
    func sendReplyMessage(with package: Package) {
        guard let conversation = self.activeConversation else {
            print("Cannot send reply message without active conversation")
            return
        }
        
        /* Your Customer Service Provider server will receive the entire content of the MSMessage.
         You can use the URL property to send user customized data to your server */
        
        let message = MSMessage(session: conversation.selectedMessage?.session ?? MSSession())
        var components = URLComponents()
        let alternateLayout = MSMessageTemplateLayout()
        
        components.queryItems = package.queryItems
        alternateLayout.caption = package.destination.name
        alternateLayout.subcaption = package.destination.formattedAddress
        message.layout = MSMessageLiveLayout(alternateLayout: alternateLayout)
        message.url = components.url
        message.summaryText = "Delivery Destination Selected" // This text will appear in the chat list
        
        conversation.insert(message) { (error) in
            if let error = error {
                print(error)
            }
        }
        
        self.dismiss()
    }
    
    func requestExpandedState() {
        requestPresentationStyle(.expanded)
    }
    
}


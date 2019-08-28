//
//  EmailFeedback.swift
//  Spinning
//
//  Created by Neil Smith on 28/08/2019.
//  Copyright © 2019 Neil Smith. All rights reserved.
//

import UIKit
import MessageUI

public final class EmailFeedback: NSObject, EmailFeedbackComposing {
    
    
    // MARK: Interface
    public static var canSend: Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    public init?(_ content: Set<EmailContent>) {
        guard MFMailComposeViewController.canSendMail() else { return nil }
        self.content = content
        super.init()
    }
    
    public var viewController: UIViewController {
        return mailViewController
    }
    
    
    // MARK: Private
    private let content: Set<EmailContent>
    
    private lazy var mailViewController: MFMailComposeViewController = {
        let vc = MFMailComposeViewController()
        for item in self.content {
            switch item {
            case .to(let addresses): vc.setToRecipients(addresses)
            case .cc(let addresses): vc.setCcRecipients(addresses)
            case .bcc(let addresses): vc.setBccRecipients(addresses)
            case .subject(let subject): vc.setSubject(subject)
            case .body(let body): vc.setMessageBody(body, isHTML: false)
            case .attachment(let attachment): vc.add(attachment)
            case .sendFrom(let address): vc.setPreferredSendingEmailAddress(address)
            }
        }
        vc.mailComposeDelegate = self
        return vc
    }()
    
}

public extension EmailFeedback {
    
    enum EmailContent: Hashable {
        case to([String])
        case cc([String])
        case bcc([String])
        case subject(String)
        case body(String)
        case attachment(Attachment)
        case sendFrom(String)
        
        public struct Attachment: Hashable {
            let data: Data
            let mimeType: String
            let fileName: String
            public init(data: Data, mimeType: String, fileName: String) {
                self.data = data
                self.mimeType = mimeType
                self.fileName = fileName
            }
        }
    }
    
}

extension EmailFeedback: MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

private extension MFMailComposeViewController {
    
    func add(_ attachment: EmailFeedback.EmailContent.Attachment) {
        self.addAttachmentData(
            attachment.data,
            mimeType: attachment.mimeType,
            fileName: attachment.fileName
        )
    }
    
}

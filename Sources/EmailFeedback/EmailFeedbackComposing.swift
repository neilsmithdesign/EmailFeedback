//
//  EmailFeedbackComposing.swift
//  
//
//  Created by Neil Smith on 28/08/2019.
//

import UIKit

public protocol EmailFeedbackComposing {
    static var canSend: Bool { get }
    init?(_ content: Set<EmailFeedback.EmailContent>)
    var viewController: UIViewController { get }
}


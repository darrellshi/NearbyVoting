//
//  MessageController.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/19/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import Messages

class MessageController {
    static let messageManager: GNSMessageManager! = GNSMessageManager(apiKey: "AIzaSyA6z_elWN3MySSVcce9gh1o75e-V4jY8XM")
    
    static var votePublication: GNSPublication?
    static var voteSubscription: GNSSubscription?
    static var responsePublication: GNSPublication?
    static var responseSubscription: GNSSubscription?
    static var resultPublication: GNSPublication?
    static var resultSubscription: GNSSubscription?
    
    static var responseTimer: Timer?
    
    static func clearAll() {
        votePublication = nil
        voteSubscription = nil
        responsePublication = nil
        responseSubscription = nil
        resultPublication = nil
        resultSubscription = nil
    }
}

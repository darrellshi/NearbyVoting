//
//  VotesManager.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/19/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import UIKit

class VotesManager {
    static var publishedVote: Vote?
    static var receivedVote: Vote?
    
    static func clearAll() {
        publishedVote = nil
        receivedVote = nil
    }
}

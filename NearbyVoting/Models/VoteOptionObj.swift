//
//  VoteOptionObj.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/19/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

class VoteOptionObj {
    var text: String?
    var responses = [Response]()
    
    init(text: String?) {
        self.text = text
    }
}

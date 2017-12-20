//
//  Vote.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/18/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import EVReflection

class Vote: EVObject {
    var title = ""
    var options:[VoteOption]!
    var numOfOptions: Int
    
    required init() {
        options = [VoteOption]()
        numOfOptions = 0
    }
    
    convenience init(title: String, options: [String]) {
        self.init()
        self.title = title
        for option in options {
            self.options.append(VoteOption(index: numOfOptions, text: option))
            self.numOfOptions += 1
        }
    }
    
    func appendOption(optionString: String) {
        self.options.append(VoteOption(index: numOfOptions, text: optionString))
        self.numOfOptions += 1
    }
}

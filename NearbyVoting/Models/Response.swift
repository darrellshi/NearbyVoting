//
//  Response.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/19/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import EVReflection

class Response: EVObject {
    var optionIndex: Int
    var username: String?
    
    required init() {
        optionIndex = -1
    }
    
    required init(optionIndex: Int) {
        self.optionIndex = optionIndex
    }
}

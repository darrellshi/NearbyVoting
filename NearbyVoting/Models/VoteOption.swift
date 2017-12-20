//
//  VoteOption.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/19/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import EVReflection

class VoteOption: EVObject {
    var index: Int
    var text: String?
    var responses: [Response]
    
    required init() {
        self.index = -1
        responses = [Response]()
    }
    
    convenience init(index: Int, text: String?) {
        self.init()
        self.index = index
        self.text = text
    }
    
    func addResponse(response: Response) {
        responses.append(response)
    }
}

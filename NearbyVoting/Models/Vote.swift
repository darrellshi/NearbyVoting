//
//  Vote.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/18/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import Foundation
import EVReflection

class Vote: EVObject {
    var title = ""
    var options = [String]()
    var optionObjs = [VoteOptionObj]()
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init() {}
    
    init(title: String, options: [String]) {
        self.title = title
        self.options.append(contentsOf: options)
        for option in options {
            self.optionObjs.append(VoteOptionObj(text: option))
        }
    }
}

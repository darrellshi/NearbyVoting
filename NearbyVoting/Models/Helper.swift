//
//  Helper.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/20/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

class Helper {
    static func getUsernamesString(responses: [Response]) -> String {
        if responses.count == 0 { return "" }
        var string = responses.first!.username!
        var i = 1
        while i < responses.count {
            string += ", \(responses[i].username ?? "anonymous")"
            i += 1
        }
        return string
    }
}

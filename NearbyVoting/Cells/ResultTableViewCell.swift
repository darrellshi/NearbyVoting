//
//  ResultTableViewCell.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/20/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var usernamesLabel: UILabel!
    
    var option: VoteOption! {
        didSet {
            optionLabel.text = option.text
            voteCountLabel.text = "\(option.responses.count)"
            usernamesLabel.text = Helper.getUsernamesString(responses: option.responses)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

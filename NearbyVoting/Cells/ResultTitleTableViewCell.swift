//
//  ResultTitleTableViewCell.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/21/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import UIKit

class ResultTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    var titleText: String? {
        didSet {
//            titleLabel.text = titleText
            let attrString = NSMutableAttributedString(string: titleText!)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 10 // change line spacing between paragraph like 36 or 48
            style.minimumLineHeight = 2 // change line spacing between each line like 30 or 40
            style.alignment = .center
            attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSRange(location: 0, length: titleText!.count))
            titleLabel.attributedText = attrString
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

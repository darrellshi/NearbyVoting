//
//  OptionTableViewCell.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/18/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    var vote: Vote?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let vote = vote {
            let ori = vote.title as NSString
            vote.title = ori.replacingCharacters(in: range, with: string)
        }

        return true
    }
}

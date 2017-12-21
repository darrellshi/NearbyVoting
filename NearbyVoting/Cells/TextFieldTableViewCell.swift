//
//  OptionTableViewCell.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/18/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var textField: UITextView!
    //    @IBOutlet weak var textField: UITextField!
    var vote: Vote?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.textColor = UIColor.lightGray
        textField.text = "Enter your question here..."
        
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        if let vote = vote {
            let ori = vote.title as NSString
            vote.title = ori.replacingCharacters(in: range, with: text)
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your question here..."
            textView.textColor = UIColor.lightGray
        }
    }
}

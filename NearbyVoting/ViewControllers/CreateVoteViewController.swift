//
//  CreateVoteViewController.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/18/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import UIKit
import Messages

class CreateVoteViewController: UITableViewController {
    
    var vote: Vote?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MessageController.voteSubscription = nil
        
        vote = Vote()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return vote!.options.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Title"
        case 1:
            return "Options"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VoteTitleCell", for: indexPath) as! TextFieldTableViewCell
            cell.vote = vote
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VoteOptionCell", for: indexPath)
            cell.textLabel?.text = vote?.options[indexPath.row].text
            return cell
        default:
            print("error")
            return tableView.dequeueReusableCell(withIdentifier: "VoteOptionCell", for: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            vote?.options.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }

    @IBAction func onAddOption(_ sender: Any) {
        let popup = UIAlertController(title: "Add Option", message: "Enter here:", preferredStyle: .alert)
        popup.addTextField { (textField) in
            textField.autocorrectionType = .default
            textField.keyboardType = .default
            textField.spellCheckingType = .default
        }
        popup.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let text = popup.textFields!.first!.text!
            self.vote?.appendOption(optionString: text)
            let indexPath = IndexPath(row: self.vote!.options.count-1, section: 1)
            self.tableView.insertRows(at: [indexPath], with: .bottom)
        }))
        self.present(popup, animated: true)
    }
    
    @IBAction func onStart(_ sender: Any) {
        if let vote = self.vote {
            let jsonData = vote.toJsonData()
            let publication = MessageController.messageManager.publication(with: GNSMessage(content: jsonData), paramsBlock: { (params) in
                guard let params = params else { return }
                params.strategy = GNSStrategy(paramsBlock: { (params) in
                    guard let params = params else { return }
                    params.discoveryMediums = .default
                    params.discoveryMode = .broadcast
                })
            })
            MessageController.votePublication = publication
            VotesManager.publishedVote = vote
            self.performSegue(withIdentifier: "ToWaitingViewController", sender: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ResultsTableViewController.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/20/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MessageController.votePublication = nil
        MessageController.responseSubscription = nil
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
//    private func tempCreateResponse(index: Int, username: String) {
//        let response = Response(optionIndex: index)
//        response.username = username
//        VotesManager.publishedVote?.options[response.optionIndex].addResponse(response: response)
//    }
//
//    private func tempFillData() {
//        VotesManager.publishedVote = Vote(title: "What would you like to have for lunch today?", options: ["Chipole", "Noodle & I", "Fazoli's", "Stacked Pickle"])
//        tempCreateResponse(index: 0, username: "darrell")
//        tempCreateResponse(index: 1, username: "april")
//        tempCreateResponse(index: 1, username: "chris")
//        tempCreateResponse(index: 1, username: "ni")
//        tempCreateResponse(index: 2, username: "david")
//        tempCreateResponse(index: 2, username: "boya")
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            guard let vote = VotesManager.publishedVote else { return 0 }
            return vote.numOfOptions
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let vote = VotesManager.publishedVote else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath)
            cell.textLabel?.text = vote.title
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTableViewCell", for: indexPath) as! ResultTableViewCell
            cell.option = vote.options[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
}

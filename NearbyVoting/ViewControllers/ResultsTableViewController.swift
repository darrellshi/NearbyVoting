//
//  ResultsTableViewController.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/20/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {
    var isMyPublication = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        MessageController.votePublication = nil
        MessageController.responseSubscription = nil
        
        if (!isMyPublication) {
            self.navigationItem.rightBarButtonItem = nil
        }
//        tempFillData()
        
    }
    
//    private func tempCreateResponse(index: Int, username: String) {
//        let response = Response(optionIndex: index)
//        response.username = username
//        VotesManager.publishedVote?.options[response.optionIndex].addResponse(response: response)
//    }
//
//    private func tempFillData() {
//        VotesManager.publishedVote = Vote(title: "What would you like to have for lunch for the secret birthday party for Nicholas Chan?", options: ["Chipole", "Noodle & I", "Fazoli's", "Stacked Pickle"])
//        tempCreateResponse(index: 2, username: "darrell")
//        tempCreateResponse(index: 1, username: "april")
//        tempCreateResponse(index: 1, username: "chris")
//        tempCreateResponse(index: 2, username: "ni")
//        tempCreateResponse(index: 2, username: "david")
//        tempCreateResponse(index: 2, username: "boya")
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onShare(_ sender: Any) {
        guard let vote = VotesManager.publishedVote else { return }

        let jsonData = vote.toJsonData()
        let gnsMessage = GNSMessage(content: jsonData, type: "RESULT")
        let publication = MessageController.messageManager.publication(with: gnsMessage!, paramsBlock: { (params) in
            guard let params = params else { return }
            params.strategy = GNSStrategy(paramsBlock: { (params) in
                guard let params = params else { return }
                params.discoveryMediums = .default
                params.discoveryMode = .broadcast
            })
        })
        MessageController.resultPublication = publication
    }

    @IBAction func onClose(_ sender: Any) {
//        MessageController.resultPublication = nil
        MessageController.clearAll()
        self.performSegue(withIdentifier: "ToMainViewController", sender: nil)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! ResultTitleTableViewCell
            cell.titleText = vote.title
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTableViewCell", for: indexPath) as! ResultTableViewCell
            cell.option = vote.options[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 90
        case 1:
            return 55
        default:
            return 0
        }
    }
}

//
//  ResultsTableViewController.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/20/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    var isMyPublication = true
    
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        MessageController.votePublication = nil
        MessageController.responseSubscription = nil
        
        if (!isMyPublication) {
            self.navigationItem.rightBarButtonItem = nil
        }
        
    
        
//        tempFillData()
        
        guard let vote = VotesManager.publishedVote else { return }
//        titleLabel.text = vote.title
        let attrString = NSMutableAttributedString(string: vote.title)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10 // change line spacing between paragraph like 36 or 48
        style.minimumLineHeight = 2 // change line spacing between each line like 30 or 40
        style.alignment = .center
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSRange(location: 0, length: vote.title.count))
        titleLabel.attributedText = attrString
    }
    
    private func tempCreateResponse(index: Int, username: String) {
        let response = Response(optionIndex: index)
        response.username = username
        VotesManager.publishedVote?.options[response.optionIndex].addResponse(response: response)
    }
    
    private func tempFillData() {
        VotesManager.publishedVote = Vote(title: "What would you like to have for lunch for the secret birthday party for Nicholas Chan?", options: ["Chipole", "Noodle & I", "Fazoli's", "Stacked Pickle"])
        tempCreateResponse(index: 2, username: "darrell")
        tempCreateResponse(index: 1, username: "april")
        tempCreateResponse(index: 1, username: "chris")
        tempCreateResponse(index: 2, username: "ni")
        tempCreateResponse(index: 2, username: "david")
        tempCreateResponse(index: 2, username: "boya")
    }
    
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
        MessageController.clearAll()
        self.performSegue(withIdentifier: "ToMainViewController", sender: nil)
    }
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vote = VotesManager.publishedVote else { return 0 }
        return vote.numOfOptions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let vote = VotesManager.publishedVote else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTableViewCell", for: indexPath) as! ResultTableViewCell
        cell.option = vote.options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

//
//  WaitingViewController.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/19/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import UIKit

class WaitingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onShowResults(_ sender: Any) {
        self.performSegue(withIdentifier: "ToResultsViewController", sender: nil)
    }
    
    private func addResponseToVote(response: Response, vote: Vote) {
        if response.optionIndex >= vote.numOfOptions {
            return
        }
        vote.options[response.optionIndex].addResponse(response: response)
    }
    
    private func listen() {
        let subscription = MessageController.messageManager.subscription(messageFoundHandler: { (message) in
            if let content = message?.content {
                let response = Response(data: content)
                if let vote = VotesManager.publishedVote {
                    self.addResponseToVote(response: response, vote: vote)
                }
            }
        }, messageLostHandler: { (message) in
            print("message loss")
        }) { (params) in
            guard let params = params else { return }
            params.strategy = GNSStrategy(paramsBlock: { (params) in
                guard let params = params else { return }
                params.discoveryMediums = .default
                params.discoveryMode = .scan
            })
        }
        MessageController.responseSubscription = subscription
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

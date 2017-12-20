//
//  MainViewController.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/18/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import UIKit
import Messages

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GNSMessageManager.setDebugLoggingEnabled(true)
        
        self.listen()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func listen() {
        let subscription = MessageController.messageManager.subscription(messageFoundHandler: { (message) in
            if let content = message?.content {
                let vote = Vote(data: content)
                VotesManager.receivedVote = vote
                self.performSegue(withIdentifier: "ToRespondVoteViewController", sender: nil)
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
        
        MessageController.voteSubscription = subscription
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

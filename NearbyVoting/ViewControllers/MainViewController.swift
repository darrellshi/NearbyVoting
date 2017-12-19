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
        MessageController.voteSubscriptions.append(MessageController.messageManager.subscription(messageFoundHandler: { (message) in
            if let content = message?.content {
                let vote = Vote(data: content)
                print(vote)
                VotesManager.received.append(vote)
                self.performSegue(withIdentifier: "ToRespondVoteViewController", sender: nil)
            }
        }) { (message) in
            if let content = message?.content {
                let string = String(data: content, encoding: .utf8)
                print(string ?? "lost")
            }
        })
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

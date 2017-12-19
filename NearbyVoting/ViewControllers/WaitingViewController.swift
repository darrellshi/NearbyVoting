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
        self.performSegue(withIdentifier: "ToWaitingViewController", sender: nil)
    }
    
    private func listen() {
        MessageController.responseSubscriptions.append(MessageController.messageManager.subscription(messageFoundHandler: { (message) in
            if let content = message?.content {
                let response = Response(data: content)
                if let vote = VotesManager.published.first {
                    vote.optionObjs[response.index!].responses.append(response)
                }
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

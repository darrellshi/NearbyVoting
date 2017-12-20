//
//  MainViewController.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/18/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import UIKit
import Messages
import TransitionButton
import DotsLoading

class MainViewController: UIViewController {
    @IBOutlet weak var createVoteButton: TransitionButton!
    var dotsLoadingView: DotsLoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GNSMessageManager.setDebugLoggingEnabled(true)
        
        self.button()
        
        self.listen()
        
        self.dotsLoadingView = DotsLoadingView(colors: [UIColor(rgb: 0x4CAF50), UIColor(rgb: 0x66BB6A), UIColor(rgb: 0x81C784), UIColor(rgb: 0xA5D6A7)])
        self.view.addSubview(dotsLoadingView)
        dotsLoadingView.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func button() {
        createVoteButton.backgroundColor = UIColor(rgb: 0x7CB342)
        createVoteButton.tintColor = UIColor.white
        createVoteButton.cornerRadius = createVoteButton.frame.height / 2
        createVoteButton.spinnerColor = .white
        createVoteButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    
    @IBAction func buttonAction(_ button: TransitionButton) {
        button.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            sleep(1)
            DispatchQueue.main.async(execute: { () -> Void in
                self.dotsLoadingView.stop()
                button.stopAnimation(animationStyle: .expand, completion: {
                    self.performSegue(withIdentifier: "ToCreateVoteViewController", sender: nil)
                })
            })
        })
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
}

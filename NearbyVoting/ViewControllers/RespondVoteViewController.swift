//
//  RespondVoteViewController.swift
//  NearbyVoting
//
//  Created by Darrell Shi on 12/18/17.
//  Copyright © 2017 Darrell Shi. All rights reserved.
//

import UIKit

class RespondVoteViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var respondOptionsTableView: UITableView!
    var vote: Vote?
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        MessageController.voteSubscription = nil
        
        respondOptionsTableView.delegate = self
        respondOptionsTableView.dataSource = self
        
        vote = VotesManager.receivedVote
        
        self.titleLabel.text = vote?.title
    }
    
    private func askForUsername() {
        let popup = UIAlertController(title: "Username", message: "Enter the name you would like everyone to see", preferredStyle: .alert)
        popup.view.tintColor = UIColor(rgb: 0x7CB342)

        popup.addTextField { (textField) in
            textField.autocorrectionType = .default
            textField.keyboardType = .default
            textField.spellCheckingType = .default
        }
        popup.addAction(UIAlertAction(title: "Anonymous", style: .default, handler: { (action) in
            UserController.username = "Anonymous"
            self.send()
        }))
        popup.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let text = popup.textFields!.first!.text {
                if (text != "") {
                    UserController.username = text
                    self.send()
                    return
                }
            }
            self.askForUsername()
        }))
        self.present(popup, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        if UserController.username == nil {
            self.askForUsername()
            return
        }
        self.send()
    }
    
    private func send() {
        if let selectedIndex = selectedIndex {
            let response = Response(optionIndex: selectedIndex)
            response.username = UserController.username
            
            let jsonData = response.toJsonData()
            let gnsMessage = GNSMessage(content: jsonData, type: "RESPONSE")
            let publication = MessageController.messageManager.publication(with: gnsMessage, paramsBlock: { (params) in
                guard let params = params else { return }
                params.strategy = GNSStrategy(paramsBlock: { (params) in
                    guard let params = params else { return }
                    params.discoveryMediums = .default
                    params.discoveryMode = .broadcast
                })
            })
            MessageController.responsePublication = publication
            
            MessageController.responseTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (_) in
                MessageController.responsePublication = nil
            })
            
            self.dismiss(animated: true, completion: nil)
        } else {
            // TODO: pop up
        }
    }
}

extension RespondVoteViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return vote == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let vote = vote {
            return vote.options.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RespondOptionTableCell", for: indexPath)
        cell.textLabel?.text = vote?.options[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

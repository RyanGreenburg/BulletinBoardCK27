//
//  MessageViewController.swift
//  BulletinBoardCK27
//
//  Created by RYAN GREENBURG on 7/8/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        MessageController.shared.fetchMessageRecords()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let messageText = textField.text, messageText != "" else { return }
        
        MessageController.shared.saveMessageRecord(messageText)
    }
    
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageController.shared.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        
        let message = MessageController.shared.messages[indexPath.row]
        
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = message.timestamp.formatDate()
        
        return cell
    }
}

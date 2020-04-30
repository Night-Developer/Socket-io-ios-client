//
//  ViewController.swift
//  TestSocketIO
//
//  Created by Luis Romero on 4/30/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var socketIdLabel: UILabel!
  var socketIOClient: SocketIOConnectionManager?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    socketIOClient = SocketIOConnectionManager(eventHandler: self.eventHandler)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    socketIOClient?.startListening()
  }
  
  private func eventHandler(params: [String: Any]) {
    if let identifier = params["client_id"] as? String {
      self.socketIdLabel.text = "Socket ID: \(identifier)"
    }
  }
  
  deinit {
    socketIOClient?.stopListening()
  }
}


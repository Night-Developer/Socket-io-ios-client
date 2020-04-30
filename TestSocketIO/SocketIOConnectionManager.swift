//
//  SocketIOConnectionManager.swift
//  TestSocketIO
//
//  Created by Luis Romero on 4/30/20.
//  Copyright © 2020 Luis Romero. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOConnectionManager {
  let manager = SocketManager(socketURL: URL(string: "http://localhost:3000/socket.io")!)

  var socket: SocketIOClient?
  var client: SocketIOClient?
  var handler: (_: [String: Any]) -> Void

  init(eventHandler: @escaping (_: [String: Any]) -> Void) {
    self.handler = eventHandler

    manager.config = SocketIOClientConfiguration(
      arrayLiteral: .compress,
      .path("/socket.io"),
      .forceWebsockets(true)
    )
    
    socket = manager.socket(forNamespace: "/")

    socket?.on(clientEvent: .connect) {data, ack in
      print("LOG: <><><><><><> socket connected")
    }

    socket?.onAny({ (event) in
      print("LOG: {}{}{}{}{}{} Event", event)
      
      if let params = event.items?.first as? [String: Any] {
        self.handler(params)
      }
    })
  }
  
  func startListening() {
    socket?.connect()
  }
  
  func stopListening() {
    self.socket?.emit("new.auctionListing.unsubscription", completion: {
      print("LOG: Stop listening")
    })
  }
}

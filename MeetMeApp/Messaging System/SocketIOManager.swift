//
//  SocketIOManager.swift
//  WebSocketsChat
//
//  Created by Bogdan Nikolaev on 17.08.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    
    //static let sharedInstance = SocketIOManager()
    
    let manager: SocketManager!
    var socket: SocketIOClient!
    
    init(nickname: String, place: Int) {
        manager = SocketManager(socketURL: URL(string: "http://macbook-pro-bogdan.local:3012")!, config: [.log(false), .compress, .connectParams(["place": place, "nickname": nickname])])
        socket = manager.defaultSocket
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func connectToServerWithNickname(nickname: String, placeID: Int) {
        listenForOtherMessages()
    }
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        socket.emit("exitUser", nickname)
        completionHandler()
    }
    
    func sendMessage(message: String, placeID: Int, withNickname nickname: String) {
        socket.emit("chatMessage", nickname, placeID, message)
    }
    
    func getHistory() {
        print("HI!!!")
        socket.emit("getHistoryMessages")
    }
    
    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            messageDictionary["nickname"] = dataArray[0] as AnyObject
            messageDictionary["message"] = dataArray[1] as AnyObject
            messageDictionary["date"] = dataArray[2] as AnyObject
            
            completionHandler(messageDictionary)
        }
    }
    
    func sendStartTypingMessage(nickname: String) {
        socket.emit("startType", nickname)
    }
    
    func sendStopTypingMessage(nickname: String) {
        socket.emit("stopType", nickname)
    }
    
    private func listenForOtherMessages() {
        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
            let notName = Notification.Name.init("userWasConnectedNotification")
            guard let obj = (dataArray[0] as? String) else {
                print("No notification about disconnected user")
                return
            }
            NotificationCenter.default.post(name: notName, object: obj)
        }
        
        socket.on("userExitUpdate") { (dataArray, socketAck) -> Void in
            let notName = Notification.Name.init("userWasDisconnectedNotification")
            guard let obj = (dataArray[0] as? String) else {
                print("No notification about disconnected user")
                return
            }
            print(obj)
            NotificationCenter.default.post(name: notName, object: obj)
        }
        
        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
            let notName = Notification.Name.init("userTypingNotification")
            NotificationCenter.default.post(name: notName, object: dataArray[0] as? [String: AnyObject])
        }
        
        socket.on("loadHistory") { (data, socketAck) in
            var messageDictionary = [[String: AnyObject]]()
            let v = data[0] as! NSArray
            for item in v {
                messageDictionary.append(item as! [String:AnyObject])
            }
            print(messageDictionary)
            let notName = Notification.Name.init("historyLoaded")
            NotificationCenter.default.post(name: notName, object: messageDictionary)
        }
        
    }
}

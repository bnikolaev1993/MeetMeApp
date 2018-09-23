//
//  ChatViewController.swift
//  WebSocketsChat
//
//  Created by Bogdan Nikolaev on 17.08.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITabBarControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tblChat: UITableView!
    
    @IBOutlet weak var lblOtherUserActivityStatus: UILabel!
    
    @IBOutlet weak var tvMessageEditor: UITextView!
    
    
    @IBOutlet weak var conBottomEditor: NSLayoutConstraint!
    
    @IBOutlet weak var lblNewsBanner: UILabel!
    
    
    
    var nickname: String!
    
    var socket: SocketIOManager!
    
    var placeID: Int!
    
    var chatMessages = [[String: AnyObject]]()
    
    var bannerLabelTimer: Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        // Do any additional setup after loading the view.
        //Hides and shows keyboards
        self.hideKeyboardWhenTappedAround()
        
        //User's connection status notifications
        NotificationCenter.default.addObserver(self, selector: #selector(handleConnectedUserUpdateNotification(notification:)), name: Notification.Name(rawValue: "userWasConnectedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDisconnectedUserUpdateNotification(notification:)), name: Notification.Name(rawValue: "userWasDisconnectedNotification"), object: nil)

        //Handle user typing action
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserTypingNotification(notification:)), name: NSNotification.Name(rawValue: "userTypingNotification"), object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tvc = self.tabBarController as! UserTabController
        nickname = tvc.currentUser.username
        socket = SocketIOManager(nickname:nickname ,place: placeID)
        if placeID == nil {
            placeID = 0
        }
        print("Chat Place ID: ", placeID)
        socket.establishConnection()
        
        configureTableView()
        configureNewsBannerLabel()
        configureOtherUserActivityLabel()
        
        chatMessages.removeAll()
        tblChat.reloadData()
        socket.connectToServerWithNickname(nickname: nickname, placeID: placeID)
        tvMessageEditor.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //socket.getHistoryMessages(placeID: placeID)
//        socket.loadHistory { (messageInfo) -> Void in
//            DispatchQueue.main.async {
//                self.chatMessages = messageInfo
//                self.tblChat.reloadData()
//                //                self.scrollToBottom()
//            }
//        }
        socket.getChatMessage { (messageInfo) -> Void in
            DispatchQueue.main.async {
                self.chatMessages.append(messageInfo)
                self.tblChat.reloadData()
                //                self.scrollToBottom()
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController != self {
           socket.closeConnection()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: IBAction Methods
    
    @IBAction func sendMessage(_ sender: Any?) {
        if tvMessageEditor.text.count > 0 {
            socket.sendMessage(message: tvMessageEditor.text!, placeID: placeID, withNickname: nickname)
            tvMessageEditor.text = ""
            tvMessageEditor.resignFirstResponder()
        }
    }
    
    
    // MARK: Custom Methods
    
    func configureTableView() {
        tblChat.delegate = self
        tblChat.dataSource = self
        tblChat.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "idCellChat")
        tblChat.estimatedRowHeight = 90.0
        tblChat.rowHeight = UITableView.automaticDimension
        tblChat.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    func configureNewsBannerLabel() {
        lblNewsBanner.layer.cornerRadius = 15.0
        lblNewsBanner.clipsToBounds = true
        lblNewsBanner.alpha = 0.0
    }
    
    
    func configureOtherUserActivityLabel() {
        lblOtherUserActivityStatus.isHidden = true
        lblOtherUserActivityStatus.text = ""
    }
    
    func scrollToBottom() {
        let delay = 0.1 * Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if self.chatMessages.count > 0 {
                let lastRowIndexPath = IndexPath(row: self.chatMessages.count - 1, section: 0)
                self.tblChat.scrollToRow(at: lastRowIndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }
    }
    
    
    func showBannerLabelAnimated() {
        UIView.setAnimationCurve(.easeInOut)
        UIView.animate(withDuration: 0.75, animations: {
            self.lblNewsBanner.alpha = CGFloat(1.0)
        }) { (finished) in
            self.bannerLabelTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.hideBannerLabel), userInfo: nil, repeats: false)
        }
    }

    
    @objc func hideBannerLabel() {
        if bannerLabelTimer != nil {
            bannerLabelTimer.invalidate()
            bannerLabelTimer = nil
        }
        
        UIView.animate(withDuration: 1, animations: {
            self.lblNewsBanner.alpha = CGFloat(0.0)
        }, completion: nil)
    }
    
    override func dismissKeyboard() {
        super.dismissKeyboard()
        socket.sendStopTypingMessage(nickname: nickname)
    }
    
    @objc func handleConnectedUserUpdateNotification(notification: Notification) {
        let connectedUserInfo = notification.object as! String
        lblNewsBanner.text = "User \(connectedUserInfo.uppercased()) was just connected."
        showBannerLabelAnimated()
    }
    
    @objc func handleDisconnectedUserUpdateNotification(notification: Notification) {
        let disconnectedUserNickname = notification.object as! String
        lblNewsBanner.text = "User \(disconnectedUserNickname.uppercased()) has left."
        showBannerLabelAnimated()
    }
    
    @objc func handleUserTypingNotification(notification: Notification) {
        if let typingUsersDictionary = notification.object as? [String: AnyObject] {
            var names = ""
            var totalTypingUsers = 0
            for (typingUser, _) in typingUsersDictionary {
                if typingUser != nickname {
                    names = (names == "") ? typingUser : "\(names), \(typingUser)"
                    totalTypingUsers += 1
                }
            }
            
            if totalTypingUsers > 0 {
                let verb = (totalTypingUsers == 1) ? "is" : "are"
                
                lblOtherUserActivityStatus.text = "\(names) \(verb) now typing a message..."
                lblOtherUserActivityStatus.isHidden = false
            }
            else {
                lblOtherUserActivityStatus.isHidden = true
            }
        }
        
    }
    
    // MARK: UITableView Delegate and Datasource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellChat", for: indexPath) as! ChatCell
        
        let currentChatMessage = chatMessages[indexPath.row]
        let senderNickname = currentChatMessage["nickname"] as! String
        let message = currentChatMessage["message"] as! String
        let messageDate = currentChatMessage["date"] as! String
        
        if senderNickname == nickname {
            cell.lblChatMessage.textAlignment = NSTextAlignment.right
            cell.lblMessageDetails.textAlignment = NSTextAlignment.right
            
            cell.lblChatMessage.textColor = lblNewsBanner.backgroundColor
        }
        
        cell.lblChatMessage.text = message
        cell.lblMessageDetails.text = "by \(senderNickname.uppercased()) @ \(messageDate)"
        
        cell.lblChatMessage.textColor = UIColor.darkGray
        
        return cell
    }
    
    
    // MARK: UITextViewDelegate Methods
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        socket.sendStartTypingMessage(nickname: nickname)
        return true
    }
    
    
    // MARK: UIGestureRecognizerDelegate Methods
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}


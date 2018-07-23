//
//  StatusSenderProtocol.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 18.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation

protocol StatusSenderProtocol: AnyObject{
    func sendStatus(status: String)
    func isLogin(status: Bool)
}

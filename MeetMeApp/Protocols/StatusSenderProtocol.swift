//
//  StatusSenderProtocol.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 18.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation
import MapKit

protocol StatusSenderProtocol: AnyObject{
    func sendStatus(status: String)
    func isLogin(status: Bool, user: User)
}

protocol CoordsSenderProtocol: AnyObject {
    func coordsRecieved(_ status: Bool, _ statusSring: String, _ place: Place?)
}

protocol UpdateMapProtocol: AnyObject {
    func updateMap()
}

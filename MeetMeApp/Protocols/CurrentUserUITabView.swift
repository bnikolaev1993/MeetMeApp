//
//  CurrentUserUITabView.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 05.08.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation
import UIKit

class UserTabController: UITabBarController {
    var currentUser = User(username: "", password: "")
    var currentCity: String = "Preston"
}

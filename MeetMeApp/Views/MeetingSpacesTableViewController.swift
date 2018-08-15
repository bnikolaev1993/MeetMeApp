//
//  MeetingSpacesTableViewController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 05.08.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

class MeetingSpacesTableViewController: UITableViewController {

    var places: [Place]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tvc = self.tabBarController as! UserTabController
        places = tvc.currentUser.placesJoined!
        print(places)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "msReusableCell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].title
        cell.detailTextLabel?.text = places[indexPath.row].subtitle
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List of Meeting Spaces you joined: "
    }
}

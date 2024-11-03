//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Visarg on 25.10.2024.
//

import UIKit

class MainViewController: UITableViewController {

    let restaurantNames = ["Burger Heroes","Kitchen", "Дастархан", "X.O", "Балкан Гриль", "Morris Pub","Вкусные истории", "Классик", "Love&Life","Шок","Бочка"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurantNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        cell.nameLabel.text = restaurantNames[indexPath.row]
        cell.imageOfPlase?.image = UIImage(named: restaurantNames[indexPath.row])
        cell.imageOfPlase?.layer.cornerRadius = cell.imageOfPlase.frame.size.height / 2
        cell.imageOfPlase?.clipsToBounds = true
        return cell
    }
    
    // MARK: - Table View Delegete
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

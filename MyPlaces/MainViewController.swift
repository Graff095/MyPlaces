//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Visarg on 25.10.2024.
//

import UIKit
import RealmSwift


class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var places: Results<Place>!
    private var filteredPlaces: Results<Place>!
    private var ascendingSorting = true
    private var searchBarIsEmpty: Bool{
        guard let text = searchController.searchBar.text else { return false}
        return text.isEmpty
    }
    private var isFitering: Bool {
        searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        places = realm.objects(Place.self)
        
        // Setup the search controller - Настройка контроллера поиска
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }

    
    // MARK: - Table view data source

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
         if isFitering{
             return filteredPlaces.count
         }
        return places.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
         let place = isFitering ? filteredPlaces[indexPath.row]: places[indexPath.row]
       
        cell.nameLabel.text = place.name
        cell.lacationLabel.text = place.location
        cell.tybeLabel.text = place.type
        cell.imageOfPlase.image = UIImage(data: place.imageData!)
        cell.cosmosView.rating = place.rating
        
        return cell
    }
    
    // MARK: - Table view delegete
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Получаем заметку
        let place = places[indexPath.row]
        
        // Создаем действие "Удалить"
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            // Удаляем объект из хранилища
            StorageManager.deleteObject(place)
            // Удаляем строку из таблицы
            tableView.deleteRows(at: [indexPath], with: .automatic)
            // Уведомляем, что действие завершено
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        // Возвращаем конфигурацию с действием
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
//     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//        let place = places[indexPath.row]
//        let deletAction = UITableViewRowAction(style: .default, title: "Delete") { _, _ in
//            
//            StorageManager.deleteObject(place)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//        
//        return [deletAction]
//    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetall" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let place = isFitering ? filteredPlaces[indexPath.row] : places[indexPath.row]
            let newPlaceVC = segue.destination as! NewPlaceViewController
            newPlaceVC.currentPlace = place
          
        }
    }
    

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
        
        
        guard let newPlaceVC = segue.source as? NewPlaceViewController else {return}
            
            newPlaceVC.savePlace()
            tableView.reloadData()
            
    }
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        
        sorting ()
    }
    
    
    @IBAction func reversedSorting(_ sender: Any) {
        
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversedSortingButton.image = UIImage(named:"AZ")
        } else {
            reversedSortingButton.image = UIImage(named:"ZA")
        }
        sorting ()
    }
    
    
    private func sorting () {
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        tableView.reloadData()
    }
    
  
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText,searchText)
        tableView.reloadData()
    }
}

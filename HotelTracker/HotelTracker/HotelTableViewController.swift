//
//  HotelTableViewController.swift
//  HotelTracker
//
//  Created by Jennifer Cohen on 24/06/2019.
//  Copyright © 2019 Jennifer Cohen. All rights reserved.
//

import UIKit
import os.log

class HotelTableViewController: UITableViewController {
    
    //MARK: Properties
    var hotels = [Hotel]()
    
    //MARK: Actions
    @IBAction func unwindToHotelList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? HotelViewController, let hotel = sourceViewController.hotel {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing hotel.
                hotels[selectedIndexPath.row] = hotel
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new hotel.
                let newIndexPath = IndexPath(row: hotels.count, section: 0)
                
                hotels.append(hotel)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveHotels()
        }
    }
    //MARK: Private Methods
    private func loadSampleHotels() {
        let photo1 = UIImage(named: "hotel1")
        let photo2 = UIImage(named: "hotel2")
        let photo3 = UIImage(named: "hotel3")
        
        guard let hotel1 = Hotel(name: "Paris hotel, Las Vegas", photo: photo1, rating: 4, comment: "Many attractions and great shows") else {
            fatalError("Unable to instantiate hotel1")
        }
        
        guard let hotel2 = Hotel(name: "Atlantis, Dubai", photo: photo2, rating: 5, comment: "With a water park and spa") else {
            fatalError("Unable to instantiate hotel2")
        }
        
        guard let hotel3 = Hotel(name: "St Regis, Mauritius", photo: photo3, rating: 3, comment: "Great pool and weather all year round") else {
            fatalError("Unable to instantiate hotel3")
        }
        hotels += [hotel1, hotel2, hotel3]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved hotels, otherwise load sample data.
        if let savedHotels = loadHotels() {
            hotels += savedHotels
        }
        else {
            loadSampleHotels()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hotels.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Table view cells reused and should be dequeud using cell identifier
        let cellIdentifier = "HotelTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HotelTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HotelTableViewCell.")
        }
        
        //Fetches the appropriate hotel for the data source layout
        let hotel = hotels[indexPath.row]
        
        cell.nameLabel.text = hotel.name
        cell.photoImageView.image = hotel.photo
        cell.ratingControl.rating = hotel.rating
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            hotels.remove(at:indexPath.row)
            saveHotels()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
/*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
*/
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new hotel.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let hotelDetailViewController = segue.destination as? HotelViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedHotelCell = sender as? HotelTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedHotelCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedHotel = hotels[indexPath.row]
            hotelDetailViewController.hotel = selectedHotel
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    private func saveHotels() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(hotels, toFile: Hotel.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Hotels successfully saved.", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save hotels...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadHotels() -> [Hotel]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Hotel.ArchiveURL.path) as? [Hotel]
    }
}

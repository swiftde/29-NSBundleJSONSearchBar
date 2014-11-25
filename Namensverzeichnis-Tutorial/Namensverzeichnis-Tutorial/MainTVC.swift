//
//  MainTVC.swift
//  Namensverzeichnis-Tutorial
//
//  Created by Benjamin Herzog on 19.10.14.
//  Copyright (c) 2014 Benjamin Herzog. All rights reserved.
//

import UIKit

class MainTVC: UITableViewController, UISearchBarDelegate {
    
    var daten = [[[String:String]]]()
    var filteredDaten = [[String:String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Namen"
        
        let hopefullyPath = NSBundle.mainBundle().pathForResource("daten", ofType: "json")
        
        if let path = hopefullyPath {
            var temp = NSData(contentsOfFile: path)!
            var tempDaten = NSJSONSerialization.JSONObjectWithData(temp, options: .MutableContainers, error: nil) as [[String:String]]
            tempDaten.sort { $0["Nachname"]! < $1["Nachname"]! }
            daten = groupWohnort(alteDaten: tempDaten)
        }
    }
    
    func groupWohnort(#alteDaten: [[String:String]]) -> [[[String:String]]] {
        var erg = [[[String:String]]]()
        var wohnortZuordnung = [String:Int]()
        
        for dic in alteDaten {
            if wohnortZuordnung[dic["Wohnort"]!] == nil {
                wohnortZuordnung[dic["Wohnort"]!] = wohnortZuordnung.count
            }
            if erg.count < wohnortZuordnung.count {
                erg.append([[String:String]]())
            }
            erg[wohnortZuordnung[dic["Wohnort"]!]!].append(dic)
        }
        
        return erg
    }
    
    func generateTextFrom(#dictionary: [String:String]) -> String {
        let nachname = dictionary["Nachname"]!
        let vorname = dictionary["Vorname"]!
        return "\(nachname), \(vorname)"
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == searchDisplayController?.searchResultsTableView {
            return 1
        }
        return daten.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchDisplayController?.searchResultsTableView {
            return filteredDaten.count
        }
        return daten[section].count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == searchDisplayController?.searchResultsTableView {
            return "Ergebnisse"
        }
        return daten[section][0]["Wohnort"]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
            cell.selectionStyle = .None
        }
        
        if tableView == searchDisplayController?.searchResultsTableView {
            cell.textLabel.text = generateTextFrom(dictionary: filteredDaten[indexPath.row])
            cell.detailTextLabel?.text = filteredDaten[indexPath.row]["Wohnort"]
        }
        else {
            cell.textLabel.text = generateTextFrom(dictionary: daten[indexPath.section][indexPath.row])
        }
        

        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredDaten.removeAll(keepCapacity: true)
        for arr in daten {
            for dic in arr {
                if (dic["Vorname"]!.lowercaseString as NSString).rangeOfString(searchText).length != 0 ||
                    (dic["Nachname"]!.lowercaseString as NSString).rangeOfString(searchText).length != 0 ||
                    (dic["Wohnort"]!.lowercaseString as NSString).rangeOfString(searchText).length != 0 {
                    filteredDaten.append(dic)
                }
            }
        }
    }

}































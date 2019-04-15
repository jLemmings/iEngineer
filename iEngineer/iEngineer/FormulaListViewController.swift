//
//  FormulaListViewController.swift
//  iEngineer
//
//  Created by Joshua Hemmings on 26.11.18.
//  Copyright © 2018 Joshua Hemmings. All rights reserved.
//

import Foundation
import UIKit

class FormulaListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var formulaList: [Model.Formula] = []
    
    var selectedCategory: String!
    var category: Model.Category!
    
    var dictonaryFavorite : [Int: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()

        self.navigationItem.title = selectedCategory
        
        formulaList = category.formulaContainer
        
        
        
        //Favoriten liste laden!
        if dictonaryFavorite.isEmpty{
            for v in formulaList{
                dictonaryFavorite[v.formulaID] = false
                //self.dictonaryFavorite[v.formulaID] = false
            }
        }
        
        
    }
    
    func onUserAction(data: String)
    {
        print("Data received: \(data)")
    }

    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFormula" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let formula = self.formulaList[indexPath.row]
                let formulaViewController = segue.destination as! FormulaViewController
                //formulaViewController.listFavorite = dictonaryFavorite
                formulaViewController.controller = self
                formulaViewController.formula = formula
                formulaViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                formulaViewController.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formulaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "formulaCell", for: indexPath)
        let object = formulaList[indexPath.row]
        cell.textLabel!.text = object.formulaName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFormula", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

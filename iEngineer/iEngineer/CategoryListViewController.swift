//
//  CategoryListViewController.swift
//  iEngineer
//
//  Created by Joshua Hemmings on 26.11.18.
//  Copyright © 2018 Joshua Hemmings. All rights reserved.
//

import Foundation
import UIKit

// COLOR ORANGE: #E8530E
// COLOR LIGHT BLUE: #183276
// COLOR DARK BLUE: #17185B
// http://uicolor.xyz/#/hex-to-ui

class CategoryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var categoryList = Model.sharedInstance.categoryModel
    var modelData = Model()
    

    
    let favoriteArray = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor  = UIColor(red:0.09, green:0.20, blue:0.46, alpha:1.0)
        navigationController?.navigationBar.tintColor = .white

        self.navigationItem.title = "iEngineer"
        categoryList = modelData.categoryModel
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView .reloadData()
        self.tableView.tableFooterView = UIView()
        tableView.dataSource = self
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFormulaList" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let category = modelData.categoryModel[indexPath.row]
                let formulaListViewController = segue.destination as! FormulaListViewController
                formulaListViewController.selectedCategory = category.categoryName
                formulaListViewController.category = category
                formulaListViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                formulaListViewController.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelData.categoryModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CustomCell
        let object = modelData.categoryModel[indexPath.row]
        cell.label.text = object.categoryName
        cell.cellImage.image = UIImage(named: object.icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFormulaList", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

class CustomCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
}


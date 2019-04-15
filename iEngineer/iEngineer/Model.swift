//
//  Model.swift
//  iEngineer
//
//  Created by Joshua Hemmings on 27.11.18.
//  Copyright © 2018 Joshua Hemmings. All rights reserved.
//

import Foundation

class Model: NSObject {
    
    static let sharedInstance = Model()
    let defaults = UserDefaults.standard
    
    var categoryModel = [Model.Category]()
    var favoriteArray = [Int: Bool]()
    
    
    struct CategoryList: Decodable {
        let data: [Model.Category]
    }
    
    struct FormulaContainer: Codable {
        let searched: String
        let formula: String
        let variableList: [String]
        
        enum CodingKeys: String, CodingKey {
            case searched = "searched"
            case formula = "formula"
            case variableList = "variable_list"
        }
    }
    
    struct Formula: Codable {
        let formulaName : String
        let formulaDescription : String
        let formulaID : Int
        let formulaImage : String
        let formulaList: [FormulaContainer]
        let favorite: Bool
        
        enum CodingKeys: String, CodingKey {
            case formulaName = "formula_name"
            case formulaDescription = "formula_description"
            case formulaID = "formula_id"
            case formulaImage = "formula_image"
            case formulaList = "formula_list"
            case favorite
        }
    }
    
    struct Category: Codable {
        let categoryName: String
        let icon: String
        let formulaContainer: [Formula]
        
        enum CodingKeys: String, CodingKey {
            case categoryName = "category_name"
            case icon = "icon"
            case formulaContainer = "formula_container"
        }
    }
    
    func loadCategoryJSONData() {
        let jsonUrlString = "http://localhost:8080/sendAllFormula"
        
        guard let url = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            guard let data = data else {return}            
            do {
                let categoryJSONData =  try JSONDecoder().decode([Model.Category].self, from: data)
                self.categoryModel = categoryJSONData
            } catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
            }.resume()
    }
    
    func loadUserDefaults() {
        favoriteArray = defaults.object(forKey: "favArray") as? [Int: Bool] ?? [Int: Bool]()
    }
    
    override init() {
        super.init()
        loadCategoryJSONData()
        loadUserDefaults()
    }
}

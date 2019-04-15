//
//  FormulaViewController.swift
//  iEngineer
//
//  Created by Joshua Hemmings on 26.11.18.
//  Copyright © 2018 Joshua Hemmings. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboard() {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
}

class FormulaViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var formulaImage: UIImageView!
    @IBOutlet weak var formulaPicker: UIPickerView!
    @IBOutlet weak var variableTable: UITableView!
    @IBOutlet weak var searchedLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!

    var controller : FormulaListViewController? = nil
    var formulaList: [Model.FormulaContainer] = []
    var formula: Model.Formula!
    let formulaViewCell = FormulaViewCustomCell()
    let defaults = UserDefaults.standard
    var variableList: [String] = []
    
    var formulaIsFavorite: Bool = false
    var formulaFavoriteArray: [Int: Bool] = [:]
    
    var selectFormel : String = ""
    var dictonary : [String: Double] = [:]
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = formula.formulaName
        variableList = formula.formulaList[0].variableList
        formulaList = formula.formulaList
        formulaImage.image = UIImage(named: formula.formulaImage)

        self.variableTable.tableFooterView = UIView()
        self.variableTable.separatorStyle = .none
        self.searchedLabel.text = formulaList[0].searched
        self.resultLabel.text = "0"
        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(resetFields))
        navigationItem.rightBarButtonItem = button
        

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        favoriteImage.isUserInteractionEnabled = true
        favoriteImage.addGestureRecognizer(tapGestureRecognizer)
        
        
        //Formel auslesen
        selectFormel = formulaList[0].formula
        
        //DSicotinary werte alle felder!
        for value in variableList {
            dictonary[value] = 0
        }
        
        print(dictonary)
        

        
        
        formulaImage.image = UIImage(named: formula.formulaImage)
        
        print("Boolean: " + String(formula.favorite))
        
        for v in (controller?.dictonaryFavorite)!{
            if v.key == formula.formulaID{
                if v.value == true{
                    favoriteImage.image = UIImage(named: "favorite_full")
                }else{
                    favoriteImage.image = UIImage(named: "favorite_outline")
                }
            }
        }
        
        self.hideKeyboard()
        
        
        //formulaFavoriteArray = defaults.object(forKey: "favArray") as? [Int: Bool] ?? [Int: Bool]()

    }
    

    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //let test = tapGestureRecognizer.view as! UIImageView
        //button image
        for v in (controller?.dictonaryFavorite)!{
            if v.key == formula.formulaID{
                if v.value == true{
                    controller?.dictonaryFavorite[v.key] = false
                    favoriteImage.image = UIImage(named: "favorite_outline")
                }else{
                    controller?.dictonaryFavorite[v.key] = true
                    favoriteImage.image = UIImage(named: "favorite_full")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    // MARK: - Picker View
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formulaList.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formulaList[row].searched + " = " + formulaList[row].formula
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        variableList = formulaList[row].variableList
        
        
        selectFormel = formulaList[row].formula

        
        self.searchedLabel.text = formulaList[row].searched
        
        self.resultLabel.text = "-"
        
        //reicht reload data? wo werden die textfelder estellet für die anzahl varaibeln?
        variableTable.reloadData()
        
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        let cell = tableView.dequeueReusableCell(withIdentifier: "variableCell", for: indexPath) as! FormulaViewCustomCell
        
        //var zeile = indexPath.row
        
        let object = variableList[indexPath.row]
        cell.label.text = object
        cell.textField.text = "0"
        cell.textField.keyboardType = UIKeyboardType.decimalPad
        
        cell.textField.addTarget(self, action: #selector(textFieldDidChange(_: )), for: .editingChanged)
        
        return cell
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            print("textField is empty")
            self.resultLabel.text = "-"
        } else {
            //Label finden das zu dem Textfield gehört!
            let cell = textField.superview?.superview as! FormulaViewCustomCell
            let text = textField.text!
            let id = cell.label.text!
            dictonary[id] = Double(text)
            print(dictonary)
            
            berechne()
        }
     }
    


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    
    @objc func resetFields() {
        print("resetedFields")
        let cells = self.variableTable.visibleCells as! Array<FormulaViewCustomCell>
        
        for cell in cells {
            cell.textField?.text = "0"
        }
        
        self.resultLabel.text = "-"
    }
    
    func textFieldShouldReturn(textField:
        UITextField!) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    
    func berechne()  {
        //let feldConvertToDouble : Double = Double(feldeingabe)!
        var refomatFormel : String = selectFormel
        
        
        //In formel Wurzel und Hochzeichen erstezen!
        if refomatFormel.range(of:"^") != nil {
            let newString = refomatFormel.replacingOccurrences(of: "^", with: "**", options: .literal, range: nil)
            print(newString)
            refomatFormel = newString as String
        }
        
        
        //In der Formel alle buchstben erstezen die mit der eingabeId überinstimmen
        for v in dictonary{
            if refomatFormel.range(of:v.key) != nil {
                let value = NSMutableString(string: refomatFormel)
                let pattern = v.key
                let regex = try? NSRegularExpression(pattern: pattern)
                regex?.replaceMatches(in: value, options: .reportProgress, range: NSRange(location: 0,length: value.length), withTemplate: "\(v.value)")
                
                print(value)
                refomatFormel = value as String
            }
        }
        
        //Prüfen ob noch ein Buchstaben nicht ersetzt wurde wenn ja kann nicht berechnet werden!
        let letters = NSCharacterSet.letters
        let phrase = refomatFormel
        let range = phrase.rangeOfCharacter(from: letters)
        
        
        if refomatFormel.range(of:"sqrt") != nil {
            print("exists")
            print("letters not found")
            //refomatFormel = "5.0/9"
            let expression = NSExpression(format: refomatFormel)
            let result = expression.expressionValue(with: nil, context: nil) as! Double
            let resultRound = Double(round(1000*result)/1000)
            
            if String(result) == "inf"{
                self.resultLabel.text = "Nicht möglich"
            }else{
                self.resultLabel.text = String(resultRound)
                print(result);
            }
        } else if range != nil {
            print("letters found")
            self.resultLabel.text = "-"
        }else {
            print("letters not found")
            //refomatFormel = "5.0/9"
            let expression = NSExpression(format: refomatFormel)
            let result = expression.expressionValue(with: nil, context: nil) as! Double
            let resultRound = Double(round(1000*result)/1000)
            
            if String(result) == "inf"{
                self.resultLabel.text = "Nicht möglich"
            }else{
                self.resultLabel.text = String(resultRound)
                print(result);
            }
        }
    }
    
    
    
    
    
}

class FormulaViewCustomCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
}

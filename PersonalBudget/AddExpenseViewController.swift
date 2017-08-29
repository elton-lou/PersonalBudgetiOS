//
//  AddExpenseViewController.swift
//  PersonalBudget
//
//  Created by Elton Lou on 8/19/17.
//  Copyright © 2017 eltonlou. All rights reserved.
//

import UIKit

class AddExpenseViewController: FirstViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var expenseDescription: UITextField!
    @IBOutlet weak var expenseAmount: UITextField!
    @IBOutlet weak var submitExpense: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        self.expenseDescription.delegate = self
        self.expenseAmount.delegate = self
        self.submitExpense.layer.cornerRadius = 5
        self.submitExpense.layer.borderWidth = 1
        self.submitExpense.layer.borderColor = UIColor.red.cgColor
        
        // create transactions SQLite table if it doesn't already exist
        let createTableAction = self.transactionTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.date)
            table.column(self.category)
            table.column(self.descript)
            table.column(self.amount)
        }
        do {
            try self.database.run(createTableAction)
            print("created table")
        } catch {
            print(error)
        }

        
    }

    @IBAction func submitExpense(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
        // insert document in SQLite transactions table
        do {
//            try self.database.run(insertTransactionIntoTableAction)
            try self.database.run("INSERT INTO transactions (date, category, description, amount) VALUES (?, ?, ?, ?)", "08-20-2017", categoryTextField.text!, expenseDescription.text!, Double(expenseAmount.text!))
            
//            let transactions = try self.database.prepare(self.transactionTable)
//            for transaction in transactions {
//                print("date: \(transaction[self.date]), category: \(transaction[self.category]), description: \(transaction[self.descript]), amount: \(transaction[self.amount])")
//            }
        } catch {
            print(error)
        }
        self.performSegue(withIdentifier: "addExpenseToSummary", sender: self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return expenseCategories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return expenseCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryTextField.text = expenseCategories[row]
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

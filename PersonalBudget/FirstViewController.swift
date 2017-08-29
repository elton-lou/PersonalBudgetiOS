//
//  FirstViewController.swift
//  PersonalBudget
//
//  Created by Elton Lou on 8/19/17.
//  Copyright © 2017 eltonlou. All rights reserved.
//

import UIKit
import SQLite

class FirstViewController: UIViewController {
    
    let expenseCategories = ["Food", "Drinks", "Entertainment", "Shopping", "Home", "Health", "Utilities", "Transportation"]
    
    var database: Connection!

    // attributes of transactions SQLite table
    let transactionTable = Table("transactions");
    let id = Expression<Int>("id");
    let date = Expression<String>("date")
    let category = Expression<String>("category")
    let descript = Expression<String>("description")
    let amount = Expression<Double>("amount")
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("transactions").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addExpense(_ sender: Any) {
        // go to the view to create an expense
        self.performSegue(withIdentifier: "toAddExpense", sender: self)
    }
    
    @IBAction func addIncome(_ sender: UIButton) {
        // go to the view to create an income
//        self.performSegue(withIdentifier: "toAddIncome", sender: self)
        do {
            let transactions = try self.database.prepare(self.transactionTable)
            for transaction in transactions {
                print("date: \(transaction[self.date]), category: \(transaction[self.category]), description: \(transaction[self.descript]), amount: \(transaction[self.amount])")
            }
        } catch {
            print(error)
        }
        

    }
    
}


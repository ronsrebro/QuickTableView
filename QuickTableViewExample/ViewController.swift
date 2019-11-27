//
//  ViewController.swift
//  QuickTableViewExample
//
//  Created by Ron Srebro on 11/26/19.
//  Copyright © 2019 ronsrebro. All rights reserved.
//

import UIKit
import QuickTableView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createButtons()
    }
    
    func createButtons() {
        
       
        let stack = UIStackView(arrangedSubviews: [createButton("Simple Test",#selector(simpleTest)),
                                                   createButton("Test Add", #selector(testAdd)),
                                                   createButton("Test Delete", #selector(testDelete)),
                                                   createButton("Test Filter", #selector(testFilter)),
                                                   createButton("Test Drill Down", #selector(testDrillDown))
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .top
        stack.distribution = .fill
        
        
        self.view.addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
    }
    
    func createButton(_ title : String,_ action: Selector) -> UIButton {
        
        let aButton = UIButton(type: .roundedRect)
        aButton.translatesAutoresizingMaskIntoConstraints = false
        aButton.setTitle(title, for: .normal)
        aButton.addTarget(self, action: action, for: .touchUpInside)
        aButton.accessibilityLabel = title
        
        return aButton
    }
    
    @objc func simpleTest() {
        
        let datasource = ["1","2","3","4"]
        let tableviewController = QuickTableViewController(dataSource: datasource)
        
        tableviewController.titleForCellAtIndex = { tableview,index in
            return tableview.dataSource![index]
        }
        
        let vc = tableviewController.modalController()
        
        self.present(vc, animated: true) {
            
        }
                
    }
    
    @objc func testAdd() {
        
        var nextNum = 5
        
        let datasource = ["1","2","3","4"]
        let tableviewController = QuickTableViewController(dataSource: datasource)
        
        tableviewController.showAddCell = true
        
        tableviewController.titleForCellAtIndex = { tableview,index in
            return tableview.dataSource![index]
        }
        
        
        tableviewController.onAdd = { controller in
            let text = String(nextNum)
            nextNum += 1
            return text
        }
        
        let vc = tableviewController.modalController()
        
        self.present(vc, animated: true) {
            
        }
    }
    
    @objc func testDelete() {
        
        var nextNum = 5
               
        var datasource = ["1","2","3","4"]
        let tableviewController = QuickTableViewController(dataSource: datasource)

        tableviewController.showAddCell = true
        tableviewController.allowDelete = true

        tableviewController.titleForCellAtIndex = { tableview,index in
           return tableview.dataSource![index]
        }


        tableviewController.onAdd = { controller in
           let text = String(nextNum)
           nextNum += 1
           return text
        }
        
        tableviewController.onDelete = { controller,index in
            datasource.remove(at: index )
        }

        let vc = tableviewController.modalController()

        self.present(vc, animated: true) {
           
        }
        
    }
    
    @objc func testFilter() {
        
        var nextNum = 5
               
        let datasource = ["1","21","3","4","11","10","22","33"]
        let tableviewController = QuickTableViewController(dataSource: datasource)

        tableviewController.showAddCell = false
        tableviewController.allowDelete = false
        
        tableviewController.showSearchBar = true

        tableviewController.titleForCellAtIndex = { tableview,index in
           return tableview.dataSource![index]
        }


        tableviewController.onAdd = { controller in
           let text = String(nextNum)
           nextNum += 1
           return text
        }
        
        tableviewController.filter = { controller, text in
            if text == "" {
                return datasource
            } else {
                return datasource.filter { (item) -> Bool in
                    return item.contains(text)
                }
            }
        }

        let vc = tableviewController.modalController()

        self.present(vc, animated: true) {
           
        }
        
    }
    
    @objc func testDrillDown() {
        
        
        var topLevel : Dictionary<String,[String]> = ["1":[],"2" : [],"3" : [],"4":[],"5":[]]
        var secondLevel : Dictionary <String,[(parent: String, name: String)]> = [:]
        
        
        
        
        for currKey in topLevel.keys {
            let count = Int(currKey) ?? 0
            for i in 0 ..< count {
                let newItem = "\(currKey)-\(i)"
                topLevel[currKey]!.append(newItem)
                secondLevel[newItem] = []
            }
        }
        
        for currKey in secondLevel.keys {
            let count = arc4random_uniform(10)
            for i in 0 ..< count {
                let newItem = (parent: currKey, name: "I am number \(i);My parent is \(currKey) ")
                secondLevel[currKey]!.append(newItem)
            }
        }
        
        let topTable = QuickTableViewController(dataSource: Array(topLevel.keys))
        let thirdTable = QuickTableViewController(dataSource: [(parent: String, name: String)]())
        let nav = UINavigationController(rootViewController: topTable)
        
        topTable.titleForCellAtIndex = { controller, index in
            let key = topTable.dataSource![index]
            return key
        }
        
        topTable.onSelection = { controller, index in
            let key = topTable.dataSource![index]
            
            let data = topLevel[key]!
            
            let newTable = QuickTableViewController(dataSource: data)
            
            newTable.titleForCellAtIndex = { controller, index in
                let key = controller.dataSource![index]                
                return key
            }
            
            newTable.onSelection = { controller, index in
                let key = controller.dataSource![index]
                
                let data = secondLevel[key]
                
                thirdTable.dataSource = data
                
                nav.pushViewController(thirdTable, animated: true)
            }
            
            nav.pushViewController(newTable, animated: true)
        }
        
        
        
        thirdTable.titleForCellAtIndex = { controller, index in
            return controller.dataSource![index].name
        }
        
        thirdTable.onSelection = { controller, index in
            let item = controller.dataSource![index]
            
            let alert = UIAlertController(title: item.parent, message: item.name, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            DispatchQueue.main.async {
                controller.present(alert, animated: true, completion: nil)
            }
            
            
        }
        
        nav.title = "Drill down"
        
        self.present(nav, animated: true) {
            
        }
        
        
        
    }


}


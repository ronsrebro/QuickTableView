//
//  QuickTableViewController.swift
//  QuickTableView
//
//  Created by Ron Srebro on 11/26/19.
//  Copyright © 2019 ronsrebro. All rights reserved.
//

import UIKit

public class QuickTableViewController<T> : UITableViewController,UISearchBarDelegate {
    
    public var dataSource : [T]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    public var tableHeaderView : UIView? {
        didSet {
            self.tableView.tableHeaderView = tableHeaderView
            
            if self.tableView.tableHeaderView != nil {
                
            }
        }
    }
    
    public var showAddCell : Bool = false {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    public var allowReorder : Bool = false {
        didSet {
            tableView.setEditing(self.allowReorder, animated: true)
        }
    }
    
    public var allowEdit : Bool = false {
        didSet {
            
        }
    }
    
    public var allowDelete : Bool = false {
        didSet {
            
        }
    }
    
    @objc public func done() {
        self.dismiss(animated: true) {
            
        }
    }
    
    public var showSearchBar : Bool = false {
        didSet {
            if showSearchBar {
                if searchBar == nil {
                    DispatchQueue.main.async {
                        self.searchBar = UISearchBar(frame: CGRect())
                        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: 50))
                        self.tableView.tableHeaderView!.addSubview(self.searchBar!)
                        self.searchBar?.pinToParent()
                        
                        self.searchBar?.delegate = self
                    }
                }
            }
        }
    }
    
    var searchBar : UISearchBar?
    
    public func modalController() -> UIViewController {
        let navController = UINavigationController(rootViewController: self)
        
        return navController
    }
    
    public override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "standardCell")
        //tableView.backgroundColor = UIColor.white
     
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else {
            return showAddCell ? 1 : 0
        }
        
        return dataSource.count + (showAddCell ? 1 : 0)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if showAddCell && indexPath.row == dataSource!.count {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "additionCell")
            cell.textLabel?.text = "Add New"
            cell.imageView?.image = UIImage(named: "Plus")
          //  cell.backgroundColor = UIColor.white
            
            if tableView.isEditing {
                cell.showsReorderControl = true
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "standardCell")!
            
            cell.textLabel?.text = titleForCellAtIndex?(self,indexPath.row) ?? "Undefined"
//            cell.backgroundColor = UIColor.white
//            cell.textLabel?.textColor = UIColor.init(named: "standardTextColor")
            
            if tableView.isEditing {
                cell.showsReorderControl = true
            }
            
            return cell
        }
    }
    
    override public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, tableView, completion) in
            if self.onDelete != nil {
                self.onDelete!(self,indexPath.row)
                self.dataSource!.remove(at: indexPath.row)
                
                completion(true)
                self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            } else {
                completion(false)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    public var titleForCellAtIndex : ((QuickTableViewController, Int) -> String)?
    public var onSelection : ((QuickTableViewController, Int) -> Void)?
    public var onAdd : ((QuickTableViewController) -> T?)?
    public var onDelete : ((QuickTableViewController, Int) -> Void)?
    public var onUpdateUI : ((QuickTableViewController) -> Void)?
    public var filter : ((QuickTableViewController, String) -> [T])?
    public var onMove : ((QuickTableViewController, T, T, Int, Int) -> Void)?
    
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if showAddCell && indexPath.row == dataSource!.count {
            if onAdd != nil {
                DispatchQueue.global(qos: .userInitiated).async {
                    if let newCell = self.onAdd!(self) {
                        DispatchQueue.main.async {
                            self.dataSource!.append(newCell)
                            tableView.insertRows(at: [IndexPath(row: self.dataSource!.count-1, section: 0)], with: .automatic)
                        }
                    }
                }
            }
            return
        }
        
        if onSelection != nil {
            onSelection!(self,indexPath.row)
        }
    }
    
    public init (dataSource : [T]) {
        self.dataSource = dataSource
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - SearchBar delegates
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if filter != nil {
            self.dataSource = filter!(self, searchBar.text ?? "")
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Tableview Reorder
    
    override public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return allowReorder
    }
    
    override public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if onMove != nil, let datasource = self.dataSource {
            
            let source = datasource[sourceIndexPath.row]
            let target = datasource[destinationIndexPath.row]
            onMove!(self,source,target,sourceIndexPath.row,destinationIndexPath.row)
        }
        
    }
    
    
}

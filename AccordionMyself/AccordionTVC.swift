//
//  AccordionTVC.swift
//  AccordionMyself
//
//  Created by Vahid Sayad on 5/29/16.
//  Copyright © 2016 Vahid Sayad. All rights reserved.
//

import UIKit

class AccordionTVC: UITableViewController {
    
    var dataArray = [TableData]()
    let indentWidth: CGFloat = 30.0
    let expandEffect: UITableViewRowAnimation = .Left
    let collapseEffect: UITableViewRowAnimation = .Right

    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0..<10 {
            let data = TableData(name: "Row Number \(i)")
            
            let rem = i % 2
            if rem == 0 {
                data.expandable = true
            } else {
                data.expandable = false
            }
            
            dataArray.append(data)
        }

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let row = self.dataArray[indexPath.row]
        
        cell.textLabel?.text = row.name
        cell.indentationLevel = row.level
        cell.indentationWidth = self.indentWidth
        
        if row.expandable {
            cell.accessoryView = self.viewForDisclousureForState(row.isExpanded)
        } else {
            cell.accessoryView = nil
        }

        return cell
    }
    
    
    func viewForDisclousureForState(isExpanded: Bool) -> UIView {
        let view = UIView(frame: CGRectMake(0, 0, 40, 40))
        var imageName = "ArrowR_blue"
        
        if isExpanded {
            imageName = "ArrowD_blue"
        }
        
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.frame = CGRectMake(0, 6, 24, 24)
        view.addSubview(imageView)
        
        return view
    }
    
    func numberOfCellsToBeCollapsed(data: TableData) -> Int{
        var total = 0
        
        if data.isExpanded {
            data.isExpanded = false
            let child = data.children
            total = child.count
        
            for item in child {
                total += self.numberOfCellsToBeCollapsed(item)
            }
        }
        
        return total
    }
 

    func collapseCellsFromIndexOf(data: TableData, indexPath: NSIndexPath, tableView: UITableView) {
        let collapseChildsCount = self.numberOfCellsToBeCollapsed(data)
        
        let endIndex = indexPath.row + 1 + collapseChildsCount
        let collapseRange = Range(indexPath.row + 1 ..< endIndex)
        
        self.dataArray.removeRange(collapseRange)
        
        data.isExpanded = false
        
        var indexPaths = [NSIndexPath]()
        for i in 0..<collapseRange.count {
            indexPaths.append(NSIndexPath.init(forRow: collapseRange.startIndex + i, inSection: 0))
        }
        
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: self.collapseEffect)
    }
    
    func expandCellFromIndexOf(data: TableData, indexPath: NSIndexPath, tableView: UITableView) {
        self.fetchChildrenforParent(data)
        
        if data.children.count > 0 {
            data.isExpanded = true
            var i = 0
            
            for row in data.children {
                dataArray.insert(row, atIndex: indexPath.row + i + 1)
                i += 1
            }
            
            let expandedRange = NSMakeRange(indexPath.row, i)
            
            var indexPaths = [NSIndexPath]()
            
            for i in 0..<expandedRange.length {
                indexPaths.append(NSIndexPath.init(forRow: expandedRange.location + i + 1, inSection: 0))
            }
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: self.expandEffect)
        }
    }
    
    func fetchChildrenforParent(parentProduct:TableData){
        
        // If canBeExpanded then only we need to create child
        if(parentProduct.expandable)
        {
            // If Children are already added then no need to add again
            if(parentProduct.children.count > 0){
                return
            }
            // The children property of the parent will be filled with this objects
            // If the parent is of type region, then fetch the location.
            if (parentProduct.type == 0) {
                for i in 0..<10
                {
                    let prod = TableData(name: "Location \(i)")
                    prod.level  = parentProduct.level + 1;
                    prod.parentName = "Child \(i) of Level \(prod.level)"
                    // This is used for setting the indentation level so that it look like an accordion view
                    prod.type = 1 //OBJECT_TYPE_LOCATION;
                    prod.isExpanded = false;
                    
                    if(i % 2 == 0)
                    {
                        prod.expandable = true
                    }
                    else
                    {
                        prod.expandable = false
                    }
                    parentProduct.children.append(prod)
                }
            }
                // If tapping on Location, fetch the users
            else{
                
                for i in 0..<10
                {
                    let prod = TableData(name: "User \(i)")
                    prod.level  = parentProduct.level + 1;
                    prod.parentName = "Child \(i) of Level \(prod.level)"
                    // This is used for setting the indentation level so that it look like an accordion view
                    prod.type = 1 //OBJECT_TYPE_LOCATION;
                    prod.isExpanded = false;
                    // Users need not expand
                    prod.expandable = false
                    parentProduct.children.append(prod)
                }
            }
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = dataArray[indexPath.row]
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if data.expandable {
            if data.isExpanded {
                self.collapseCellsFromIndexOf(data, indexPath: indexPath, tableView: tableView)
                selectedCell?.accessoryView = self.viewForDisclousureForState(false)
            } else {
                self.expandCellFromIndexOf(data, indexPath: indexPath, tableView: tableView)
                selectedCell?.accessoryView = self.viewForDisclousureForState(true)
            }
        }
    }


}

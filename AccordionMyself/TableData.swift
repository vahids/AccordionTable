//
//  TableData.swift
//  AccordionMyself
//
//  Created by Vahid Sayad on 5/29/16.
//  Copyright © 2016 Vahid Sayad. All rights reserved.
//

import Foundation

class TableData{
    private var _name: String
    private var _expandable: Bool
    private var _isExpanded: Bool
    private var _level: Int
    private var _type: Int
    private var _parentName: String
    
    var children = [TableData]()
    
    var parentName: String{
        get{
            return self._parentName
        }
        set{
            self._parentName = newValue
        }
    }
    
    var type: Int {
        get{
            return self._type
        }
        
        set{
            self._type = newValue
        }
    }
    
    var level: Int{
        get {
            return self._level
        }
        
        set{
            self._level = newValue
        }
    }
    
    var isExpanded: Bool {
        get{
            return self._isExpanded
        }
        
        set{
            self._isExpanded = newValue
        }
    }
    
    var expandable: Bool{
        get {
            return self._expandable
        }
        
        set {
            self._expandable = newValue
        }
    }
    
    var name: String{
        return self._name
    }
    
    init(name: String) {
        self._expandable = false
        self._isExpanded = false
        self._name = name
        self._level = 0
        self._type = 0
        self._parentName = ""
    }
    
}
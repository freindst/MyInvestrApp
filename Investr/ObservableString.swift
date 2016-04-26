//
//  ObservableString.swift
//  Investr
//
//  Created by Michael Litman on 10/2/15.
//  Copyright © 2015 Timothy Huesmann. All rights reserved.
//

import UIKit


protocol Observable
{
    func observableStringUpdate(newValue: String, identifier: String);
}

class ObservableString: NSObject
{
    var observers = NSMutableArray()
    var identifier = ""
    
    var value = ""{willSet(newValue){
        print("About to set")
        for observer in observers
        {
            (observer as! Observable).observableStringUpdate(newValue, identifier: identifier)
        }

        }
        didSet(newValue){
            print("Did set")
            //let the observers know
                    }
    }
    
    func updateValue(value: String)
    {
        self.value = value
    }
    
    init(value: String, identifier: String)
    {
        self.value = value
        self.identifier = identifier
    }
    
    func addObserver(observer: AnyObject)
    {
        self.observers.addObject(observer)
    }
}

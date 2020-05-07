//
//  debug.swift
//  Boobay
//
//  Created by MacBook on 14/10/19.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
import UIKit

// This class is used for handling Logs. innorder to hide every logs in the project, just change the value of variable showLog to False

// WARNING: DO NOT PRINT LOGS DIRECTLY ANYWHERE IN THE PROJECT

class debug {
    
    var showLog : Bool = true   //Set ShowLog as false while building for production && true for testing
    
    func print(items: Any...) {
        if self.showLog == true
            
        {
            Swift.print(items);
        }
        
        
    }
    
    func debugPrint(items: Any...) {
        if self.showLog == true
        {
            Swift.debugPrint(items);
        }
    }
    
    
}

//
//  Section.swift
//  HW44CoreData
//
//  Created by Сергей on 28.05.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation

class Section {
    
    var name: String? = nil
    var objects: [Any]? = nil
    
    init(name: String, objects: [Any]?) {
        self.name = name
        self.objects = objects
    }
    
}

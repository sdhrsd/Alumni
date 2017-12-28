                                                 
//
//  Users.swift
//  SDSUAlumni
//
//  Created by Admin on 12/22/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import Foundation

struct Users : ImageProtocol{

    private(set) public var name:String
    private(set) public var degree:String
    private(set) public var college:String
    private(set) public var city:String
    private(set) public var state:String
    private(set) public var year:String
    private(set) public var id:String
    private(set) public var country:String
    var profileImage:String?
    
    init(name:String,degree:String,college:String,city:String,state:String,year:String,country:String,id:String){
        self.name = name
        self.degree = degree
        self.college = college
        self.city = city
        self.state = state
        self.year = year
        self.id = id
        self.country = country
    }
}
protocol ImageProtocol {
    var profileImage: String? { get set }
}

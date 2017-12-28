                                           /* Name : Hera Siddiqui
                                            RedId: 819677411
                                            Date: 12/24/2017 */
//
//  Message.swift
//  SDSUAlumni
//
//  Created by Admin on 12/22/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit

struct Message:ImageProtocol {
    
    private(set) public var sendName:String
    private(set) public var sendId:String
    private(set) public var timestamp:Double
    private(set) public var sentMessage:String
    var profileImage:String?
    init(sendName:String,sendId:String,timestamp:Double,sentMessage:String){
        self.sendName = sendName
        self.sendId = sendId
        self.sentMessage = sentMessage
        self.timestamp = timestamp
    }

}

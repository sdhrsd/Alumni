                                           /* Name : Hera Siddiqui
                                            RedId: 819677411
                                            Date: 12/24/2017 */

//
//  CustomTextField.swift
//  SDSUAlumni
//
//  Created by Admin on 12/17/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if (action == #selector(paste(_:)) || action == #selector(cut(_:)) || action == #selector(replace(_:withText:))) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }

}

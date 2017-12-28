                                            /* Name : Hera Siddiqui
                                             RedId: 819677411
                                             Date: 12/24/2017 */
//
//  Image.swift
//  SDSUAlumni
//
//  Created by Admin on 12/22/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit

let storedImage = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func storeImage(urlProfile:String) {
        self.image = nil
        if let alreadyStoredImage = storedImage.object(forKey: urlProfile as AnyObject) {
            self.image = alreadyStoredImage as? UIImage
            return
        }
        
        if let url = URL(string: urlProfile) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if(error != nil){
                    print(error!)
                    return
                }
                if let data = data {
                    DispatchQueue.main.async {
                        if let downloadedImage = UIImage(data:data){
                            storedImage.setObject(downloadedImage, forKey: urlProfile as AnyObject)
                            self.image = downloadedImage

                        }
                    }
                }
            }).resume()
        }
    }
}
/*https://www.youtube.com/channel/UCuP2vJ6kRutQBfRmdcI92mA */

//
//  Media.swift
//  FaceAnalytic
//
//  Created by K2 on 5.03.2018.
//  Copyright © 2018 K2. All rights reserved.
//

import UIKit

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image:UIImage, forKey key: String){
        self.key=key
        self.mimeType="image/jpeg"
        self.filename="testimg.jpg"
        guard let data = UIImageJPEGRepresentation(image, 0.7) else {return nil}
        self.data=data
    }
}

//
//  TermsController.swift
//  FaceAnalytic
//
//  Created by K2 on 9.07.2018.
//  Copyright © 2018 K2. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class TermsController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var termsText: UITextView!
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        termsText.setContentOffset(CGPoint.zero,animated: false)
    }
    

    
    
}

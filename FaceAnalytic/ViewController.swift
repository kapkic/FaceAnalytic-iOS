//
//  ViewController.swift
//  FaceAnalytic
//
//  Created by K2 on 3.03.2018.
//  Copyright © 2018 K2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var txtMail : UITextField!
    @IBOutlet var btnPhoto : UIButton!
    @IBOutlet var btnSend : UIButton!
    var photo=false;
    var mail=false;
    var switchbut=false;
   
    
    @IBAction func PhotoPress(_ sender: Any) {
        photo=true;
        if (mail && photo && switchbut)
        {
            
            btnSend.isEnabled=true;
        }
        else
        {
            btnSend.isEnabled=false;
        }
    }
    @IBAction func MailEntered(_ sender: Any) {
        mail=true;
        if (mail && photo && switchbut)
        {
            btnSend.isEnabled=true;
        }
        else
        {
            btnSend.isEnabled=false;
        }
    }
    @IBAction func Switch(_ sender: Any) {
        switchbut = !switchbut;
        if (mail && photo && switchbut)
        {
            btnSend.isEnabled=true;
        }
        else
        {
            btnSend.isEnabled=false;
        }
    }
    @IBAction func StartAnalysis(_ sender: Any) {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         btnSend.isEnabled=false;
        mail=true;
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  ViewController.swift
//  FaceAnalytic
//
//  Created by K2 on 3.03.2018.
//  Copyright © 2018 K2. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var txtMail : UITextField!
    @IBOutlet var btnPhoto : UIButton!
    @IBOutlet var btnSend : UIButton!
    @IBOutlet var termsText: UITextView!
    
    var photo=false;
    var mail=false;
    var switchbut=false;
    typealias Parameters = [String: String]
    @IBOutlet var ImageView: UIImageView!
    
    
    @IBAction func PhotoPress(_ sender: Any) {
        let imagecontroller = UIImagePickerController()
        imagecontroller.delegate=self
        imagecontroller.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagecontroller, animated:true, completion: nil)
        photo=true;
        if (mail && photo && switchbut)
        {
        btnSend.isEnabled=true;
        }else{
        btnSend.isEnabled=false;
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        ImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CamPress(_ sender: Any) {
        let imagecontroller = UIImagePickerController()
        imagecontroller.delegate=self
        imagecontroller.sourceType = .camera
        self.present(imagecontroller, animated:true, completion: nil)
        photo=true;
        if (mail && photo && switchbut)
        {
            btnSend.isEnabled=true;
        }else{
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
        print ("woahSwitch")
    }
    
    
    @IBAction func StartAnalysis(_ sender: Any) {
        //TODO let's write the fucking history.

        let url = "https://www.faceanalytic.com/yukle" /* your API url */
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        
        let parameters = ["email":"thesadr@gmail.com","termsofuse":"1"]
       // UIImage *imageUpl = [imageView image];
        let imageData = UIImageJPEGRepresentation(ImageView.image!, 4.0)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "facephoto", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseString { response in
                    print("Succesfully uploaded")
                    if let err = response.error{
                        print ("Error1 is:")
                        print (err)
                        print ("Response is:")
                        print (response)
                        return
                    }
                    else{
                        let alert = UIAlertController(title: "Fotograf Gonderildi", message: "Fotoğrafınıza dair kişilik sonuçları e-posta adresinize gönderilmiştir. Lütfen e-posta kutunuzu kontrol ediniz, sonuç alamamanız durumunda face2personality@gmail.com adresinden iletişime geçebilirsiniz.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))                        
                        self.present(alert, animated: true)
                    }
                    print ("Completed")
                    //print (String(data:err,encoding: String.Encoding.utf8) as String!)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                print ("Error2 is:")
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         //btnSend.isEnabled=false;
        mail=true;
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}
extension Data {
    mutating func append(_ string: String){
        if let data = string.data(using: .utf8){
            append(data)
            print (String(data:data,encoding: String.Encoding.utf8) as String!)
        }
    }
}

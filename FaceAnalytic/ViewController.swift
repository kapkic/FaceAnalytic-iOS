//
//  ViewController.swift
//  FaceAnalytic
//
//  Created by K2 on 3.03.2018.
//  Copyright © 2018 K2. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_ButtonThemer

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}

class ViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var txtMail : UITextField!
    @IBOutlet var btnPhoto : UIButton!
    @IBOutlet var btnSend : UIButton!
    
    var photo=false;
    var mail=false;
    typealias Parameters = [String: String]
    @IBOutlet var ImageView: UIImageView!

    let imageSourceTitle = NSLocalizedString("Choose Image Source", comment: "")
    let cameraText = NSLocalizedString("Camera", comment: "")
    let galleryText = NSLocalizedString("Gallery", comment: "")
    let cancelText = NSLocalizedString("Cancel", comment: "")
    let photoSentTitle = NSLocalizedString("Photo Sent", comment: "")
    let photoSentText = NSLocalizedString("Personality analysis results have been sent to your e-mail. Please check your email inbox, please contact us at face2personality@gmail.com if you cannot get any results.", comment: "")
    let okayText = NSLocalizedString("Okay", comment: "")
    let loadingText = NSLocalizedString("Please wait...", comment: "")
    let internetErrorTitle = NSLocalizedString("Internet Connection Error", comment: "")
    let internetErrorText = NSLocalizedString("Unable to connect to the internet. Please make sure your device is connected to a network and try again.", comment: "")
    
    //TODO: implement
    let faceErrorTitle = NSLocalizedString("An Error Occurred While Analyzing.", comment: "")
    let faceErrorText = NSLocalizedString("Please fix the following issues and try again:\nThere are not enough facial features or there are multiple people in the photo.\nPhoto is not clear enough.\nPhoto should be taken from the front side.", comment: "")
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        ImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showActionSheet(_ sender: Any) {
        let optionMenu = UIAlertController(title:nil,message:imageSourceTitle,preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title:cameraText,style:.default,handler:{
            action in self.getPhoto()
        })
        
        let galleryAction = UIAlertAction(title:galleryText,style:.default,handler:{
            action in self.getGallery()
        })
       
        let cancelAction =  UIAlertAction(title:cancelText,style:.cancel,handler:{
            (action) -> Void in print ("Cancel Pressed")
        })
        
        optionMenu.addAction(photoAction)
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu,animated: true,completion:nil)
    }
    
    func getPhoto ()
    {
        let imagecontroller = UIImagePickerController()
        imagecontroller.delegate=self
        imagecontroller.sourceType = .camera
        self.present(imagecontroller, animated:true, completion: nil)
        photo=true;
        print ("photo selected camera")
        if (mail && photo)
        {
            btnSend.layer.borderColor = UIColor.blue.cgColor
            btnSend.isEnabled=true;
        }else{
            btnSend.layer.borderColor = UIColor.gray.cgColor
            btnSend.isEnabled=false;
        }
    }
    
    func getGallery ()
    {
        let imagecontroller = UIImagePickerController()
        imagecontroller.delegate=self
        imagecontroller.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagecontroller, animated:true, completion: nil)
        photo=true;
        print ("photo selected gallery")
        if (mail && photo)
        {
            btnSend.isEnabled=true;
        }else{
            btnSend.isEnabled=false;
        }
    }
    
    @IBAction func MailEntered(_ sender: Any) {
        txtMail.returnKeyType = UIReturnKeyType.done
        
        let mailAddress: String = txtMail.text!
        if validateEmail(candidate: mailAddress)
        {
            mail=true;
            print ("mail entered True")
        }
        else
        {
            mail=false;
            print ("mail entered False")
        }
        
        if (mail && photo)
        {
            btnSend.isEnabled=true;
        }
        else
        {
            btnSend.isEnabled=false;
        }
    }
    

    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with:candidate)
    }
    
    /*@IBAction func Switch(_ sender: Any) {
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
    */
    
    @IBAction func StartAnalysis(_ sender: Any) {
        //TODO let's write the fucking history.
        
        
        if Connectivity.isConnectedToInternet {
            let alert_load = UIAlertController(title: nil, message: loadingText, preferredStyle: .alert)
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            
            alert_load.view.addSubview(loadingIndicator)
            present(alert_load, animated: true, completion: nil)
            print("Connected")
        

        let url = "https://www.faceanalytic.com/yukle" /* your API url */
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        let mailAddress: String = txtMail.text!
        
        let parameters = ["email":mailAddress,"termsofuse":"1"]
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
                    
                    else if response.result.value?.range(of: "Lütfen aşağıdaki hataları düzelterek") != nil
                {
                    alert_load.dismiss(animated: false, completion: nil)
                    let alert_faceError = UIAlertController(title: self.faceErrorTitle, message: self.faceErrorText, preferredStyle: .alert)
                    alert_faceError.addAction(UIAlertAction(title: self.okayText, style: .default, handler: nil))
                    self.present(alert_faceError, animated: true)
                    print ("faceError")
                    return
                }
                    else{
                        alert_load.dismiss(animated: false, completion: nil)
                        let alert_sent = UIAlertController(title: self.photoSentTitle, message: self.photoSentText, preferredStyle: .alert)
                        alert_sent.addAction(UIAlertAction(title: self.okayText, style: .default, handler: nil))
                        self.present(alert_sent, animated: true)
                        print ("Succ")
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
        else {
            print("err connect")
            let alert_network = UIAlertController(title: internetErrorTitle, message: internetErrorText, preferredStyle: .alert)
            alert_network.addAction(UIAlertAction(title: okayText, style: .default, handler: nil))
            self.present(alert_network, animated: true)
        }
}

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let button = MDCButton()
//        let buttonScheme = MDCButtonScheme()
//        MDCOutlinedButtonThemer.applyScheme(buttonScheme, to: button)

        //ManualOverride
//        btnSend.backgroundColor = .clear
//        btnSend.layer.cornerRadius = 5
//        btnSend.layer.borderWidth = 1
//        btnSend.layer.borderColor = UIColor.gray.cgColor
        btnSend.isEnabled=false;
        txtMail.returnKeyType = UIReturnKeyType.done
        txtMail.delegate = self
        //mail=true;
        // Do any additional setup after loading the view, typically from a nib.
    }
    func textFieldShouldReturn(_ txtMail: UITextField) -> Bool{
        txtMail.resignFirstResponder()
        return true
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

//
//  ViewController.swift
//  FaceAnalytic
//
//  Created by K2 on 3.03.2018.
//  Copyright © 2018 K2. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet var txtMail : UITextField!
    @IBOutlet var btnPhoto : UIButton!
    @IBOutlet var btnSend : UIButton!
    var photo=false;
    var mail=false;
    var switchbut=false;
    typealias Parameters = [String: String]
    
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
        let imageData = UIImageJPEGRepresentation(#imageLiteral(resourceName: "testimg"), 4.0)
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
                    print ("Completed")
                    //print (String(data:err,encoding: String.Encoding.utf8) as String!)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                print ("Error2 is:")
            }
        }
        
        
        
//
//        print ("woah")
//        /*inputs
//        input-text name=email type=text
//         tick-mark name=termsofuse value=0 type=checkbox
//         id=imgToUpload name=facephoto type=file
//         */
//        let myUrl = URL(string: "http://www.faceanalytic.com/yukle");
//        var request = URLRequest(url:myUrl!)
//        request.httpMethod = "POST"
//        //let postString = "thesadr@gmail.com";
//
//
//        //multipart
//        let parameters = ["email":"thesadr@gmail.com","termsofuse":"1"]
//        let boundary = generateBoundary()
//        guard let mediaImage = Media(withImage: #imageLiteral(resourceName: "testimg"), forKey:"facephoto") else {return}
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        let dataBody = createDataBody(withParameters: parameters, media:[mediaImage], boundary: boundary)
//        request.httpBody = dataBody
//
//        let session = URLSession.shared
//        session.dataTask(with: request) { (data,response,error) in
//            if let response=response {
//                print (response)
//            }
//            if let data=data {
//                print ("Data is:")
//                print (String(data:data,encoding: String.Encoding.utf8) as String!)
//                do{
//                    let json=try JSONSerialization.jsonObject(with: data, options: [])
//                    print(json)
//                }
//                catch {
//                    print(error)
//                }
//            }
//        }.resume()
//        //
        
    }
//
//    func generateBoundary() -> String {
//        return "Boundary-\(NSUUID().uuidString)"
//    }
//    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
//        let lineBreak = "\r\n"
//        var body = Data()
//
//        if let parameters = params {
//            for (key, value) in parameters {
//                body.append("--\(boundary + lineBreak)")
//                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
//                body.append("\(value+lineBreak)")
//            }
//        }
//        if let media=media {
//            for photo in media{
//                body.append("--\(boundary + lineBreak)")
//                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
//                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
//                body.append(photo.data)
//                body.append(lineBreak)
//            }
//        }
//        body.append("--\(boundary)--\(lineBreak)")
//        return body
//    }
    
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

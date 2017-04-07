//
//  HowToUseAppViewController.swift
//  HardingLaw
//
//  Created by mobile developer on 2017. 02. 21..
//  Copyright © 2017. mobile developer. All rights reserved.
//

import Foundation

import UIKit
import GooglePlacePicker

import MessageUI

import Firebase
import UICircularProgressRing

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

class NewInjuryViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate  {
    @IBOutlet var locationField: UITextField!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var timeField: UITextField!

    @IBOutlet var yourName: UITextField!
    @IBOutlet var yourPhone: UITextField!
    @IBOutlet var yourAddress: UITextField!
    @IBOutlet var yourLicense: UITextField!
    
    @IBOutlet var driverName: UITextField!
    @IBOutlet var driverPhone: UITextField!
    @IBOutlet var driverLicense: UITextField!
    @IBOutlet var vehicleModel: UITextField!
    @IBOutlet var insuranceCompany: UITextField!
    
    @IBOutlet var witnessName1: UITextField!
    @IBOutlet var witnessPhone1: UITextField!
    @IBOutlet var witnessName2: UITextField!
    @IBOutlet var witnessPhone2: UITextField!

    @IBOutlet var injuredName1: UITextField!
    @IBOutlet var injuredPhone1: UITextField!

    @IBOutlet var injuredName2: UITextField!
    @IBOutlet var injuredPhone2: UITextField!

    @IBOutlet var policeName: UITextField!
    @IBOutlet var policeNumber: UITextField!
    @IBOutlet var policeReportNumber: UITextField!

    
    
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    
    var imagePicker: UIImagePickerController!
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    @IBOutlet var imageView4: UIImageView!
    @IBOutlet var imageView5: UIImageView!
    @IBOutlet var imageView6: UIImageView!
    
    var accidentPhoto1: String! = ""
    var accidentPhoto2: String! = ""
    var accidentPhoto3: String! = ""
    var injuredPhoto1: String! = ""
    var injuredPhoto2: String! = ""
    var policePhoto: String! = ""
    
    
    var strLatitude:String! = "0"
    var strLongitue:String! = "0"
    
    var nBtnTag = 0;
    
    var storageRef : FIRStorageReference = FIRStorageReference()
    
    var imgCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pickLocation() {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: { (place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place selected")
                return
            }
            
            if let formattedAddress = place.formattedAddress{
                self.locationField.text=place.name + " - " + formattedAddress
                
            }else{
                self.locationField.text=place.name
                print("gmsPlace.formattedAddress is nil")
            }
            
            let attributedString = NSMutableAttributedString(string: "VIEW MAP")
            attributedString.addAttribute(NSLinkAttributeName, value: "https://www.google.com/maps?q=" + String(place.coordinate.latitude) + "," + String(place.coordinate.longitude), range: NSRange(location: 0, length: 8))
            
            self.locationField.attributedText = attributedString
            
            self.strLatitude = String(place.coordinate.latitude)
            self.strLongitue = String(place.coordinate.longitude)
            
            print("Place name \(place.name)")
            print("Place address \(place.formattedAddress)")
            print("Place attributions \(place.attributions)")
            print("Place \(place)")
            
            self.closekeyboard()
        })
    }
    
    @IBAction func pickDate() {
        self.dateField.becomeFirstResponder()
    }

    @IBAction func pickTime() {
        self.timeField.becomeFirstResponder()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            closekeyboard()
        } else if textField.tag == 2 {
            datePicker1.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePicker1
            datePicker1.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
        } else if textField.tag == 3 {
            datePicker2.datePickerMode = UIDatePickerMode.time
            textField.inputView = datePicker2
            datePicker2.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
        }
        print("This Worked")
    }
    
    // MARK: Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closekeyboard()
    }
    
    func closekeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        if sender == datePicker1
        {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            dateField.text = formatter.string(from: sender.date)
        } else if sender == datePicker2 {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            timeField.text = formatter.string(from: sender.date)
        }
        print("Try this at home")
    }
    
    @IBAction func takePhoto(sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        nBtnTag = sender.tag
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        switch nBtnTag {
        case 111:
            imageView1.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            imgCount += 1
            break
        case 112:
            imageView2.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            imgCount += 1
            break
        case 113:
            imageView3.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            imgCount += 1
            break
        case 114:
            imageView4.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            imgCount += 1
            break
        case 115:
            imageView5.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            imgCount += 1
            break
        case 116:
            imageView6.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            imgCount += 1
            break
        default:
            break
        }
    }
    
    func showToast(string: String!, focus: Bool = false, textField:UITextField! = nil) {
        let toastLabel = UILabel(frame: CGRect(x:self.view.frame.size.width/2 - 150, y:self.view.frame.size.height/2, width:300, height:35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(toastLabel)
        toastLabel.text = string
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true

        if focus {
            textField.becomeFirstResponder()
        }
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            toastLabel.alpha = 0.0
            
        })
    }
    
    func uploadingPhotos() {
        let currentUser = FIRAuth.auth()?.currentUser
        
        
        let progressRing = UICircularProgressRingView(frame: CGRect(x: view.frame.width/2 - 75, y: view.frame.height/2-75, width: 170, height: 170))
        // Change any of the properties you'd like
        progressRing.maxValue = 100
        progressRing.outerRingColor = UIColor.green
        progressRing.innerRingColor = UIColor.blue
        progressRing.valueIndicator = "% uploaded"
        self.view.addSubview(progressRing)
        
        var uploadValue:CGFloat = 0;
        let step:CGFloat = 100.0/CGFloat(imgCount);
        var completedUploading = 0;
        //uploading image1
        
        let newMetadata = FIRStorageMetadata()
        newMetadata.cacheControl = "public,max-age=300";
        newMetadata.contentType = "image/jpeg";
        
        if imageView1.image != nil,  let uploadData = UIImageJPEGRepresentation(imageView1.image!, 0.5) {
            
            if let uid = currentUser?.uid {
                let ticks = Date().ticks
                storageRef = FIRStorage.storage().reference().child("InjuryPictures/\(uid)/\(ticks).jpg")
            }
            
            
            let uploadTask = storageRef.put(uploadData, metadata: newMetadata) { snapshot, error in
                if let error = error {
                    print(error)
                }
            }
            
            // Shows progress bar until saved
            uploadTask.observe(.progress) { snapshot in
                //progressBar1.observedProgress = snapshot.progress
                uploadValue += CGFloat((snapshot.progress?.fractionCompleted)!)*step
                uploadValue = uploadValue > 100 ? 100: uploadValue
                progressRing.setProgress(value: uploadValue, animationDuration: 1.0)
            }
            
            uploadTask.observe(.success) { snapshot in
                if let profileImageURL = snapshot.metadata?.downloadURL()?.absoluteString {
                    completedUploading += 1;
                    self.accidentPhoto1 = "<a href=" + profileImageURL + ">VIEW PHOTO</a><br>"
                    if completedUploading == self.imgCount {
                        progressRing.removeFromSuperview()
                        progressRing.isHidden = true
                        self.submit()
                    }
                }
            }
        }
        
        //uploading image2
        if imageView2.image != nil,  let uploadData = UIImageJPEGRepresentation(imageView2.image!, 0.5) {
            
            if let uid = currentUser?.uid {
                let ticks = Date().ticks
                storageRef = FIRStorage.storage().reference().child("InjuryPictures/\(uid)/\(ticks).jpg")
            }
            
            let uploadTask = storageRef.put(uploadData, metadata: newMetadata) { snapshot, error in
                if let error = error {
                    print(error)
                }
            }
            
            // Shows progress bar until saved
            uploadTask.observe(.progress) { snapshot in
                uploadValue += CGFloat((snapshot.progress?.fractionCompleted)!)*step
                uploadValue = uploadValue > 100 ? 100: uploadValue
                progressRing.setProgress(value: uploadValue, animationDuration: 1.0)
            }
            
            uploadTask.observe(.success) { snapshot in
                if let profileImageURL = snapshot.metadata?.downloadURL()?.absoluteString {
                    completedUploading += 1;
                    self.accidentPhoto2 = "<a href=" + profileImageURL + ">VIEW PHOTO</a><br>"
                    if completedUploading == self.imgCount {
                        progressRing.removeFromSuperview()
                        progressRing.isHidden = true
                        self.submit()
                    }
                }
            }
        }
        
        //uploading image3
        if imageView3.image != nil,  let uploadData = UIImageJPEGRepresentation(imageView3.image!, 0.5) {
            
            if let uid = currentUser?.uid {
                let ticks = Date().ticks
                storageRef = FIRStorage.storage().reference().child("InjuryPictures/\(uid)/\(ticks).jpg")
            }
            
            let uploadTask = storageRef.put(uploadData, metadata: newMetadata) { snapshot, error in
                if let error = error {
                    print(error)
                }
            }
            
            // Shows progress bar until saved
            uploadTask.observe(.progress) { snapshot in
                uploadValue += CGFloat((snapshot.progress?.fractionCompleted)!)*step
                uploadValue = uploadValue > 100 ? 100: uploadValue
                progressRing.setProgress(value: uploadValue, animationDuration: 1.0)
            }
            
            uploadTask.observe(.success) { snapshot in
                if let profileImageURL = snapshot.metadata?.downloadURL()?.absoluteString {
                    completedUploading += 1;
                    self.accidentPhoto3 = "<a href=" + profileImageURL + ">VIEW PHOTO</a><br>"
                    if completedUploading == self.imgCount {
                        progressRing.removeFromSuperview()
                        progressRing.isHidden = true
                        self.submit()
                    }
                }
            }
        }
        
        //uploading image4
        if imageView4.image != nil, let uploadData = UIImageJPEGRepresentation(imageView4.image!, 0.5) {
            
            if let uid = currentUser?.uid {
                let ticks = Date().ticks
                storageRef = FIRStorage.storage().reference().child("InjuryPictures/\(uid)/\(ticks).jpg")
            }
            
            let uploadTask = storageRef.put(uploadData, metadata: newMetadata) { snapshot, error in
                if let error = error {
                    print(error)
                }
            }
            
            // Shows progress bar until saved
            uploadTask.observe(.progress) { snapshot in
                uploadValue += CGFloat((snapshot.progress?.fractionCompleted)!)*step
                uploadValue = uploadValue > 100 ? 100: uploadValue
                progressRing.setProgress(value: uploadValue, animationDuration: 1.0)
            }
            
            uploadTask.observe(.success) { snapshot in
                if let profileImageURL = snapshot.metadata?.downloadURL()?.absoluteString {
                    completedUploading += 1;
                    self.injuredPhoto1 = "<a href=" + profileImageURL + ">VIEW PHOTO</a><br>"
                    if completedUploading == self.imgCount {
                        progressRing.removeFromSuperview()
                        progressRing.isHidden = true
                        self.submit()
                    }
                }
            }
        }

        //uploading image5
        if imageView5.image != nil, let uploadData = UIImageJPEGRepresentation(imageView5.image!, 0.5) {
            
            if let uid = currentUser?.uid {
                let ticks = Date().ticks
                storageRef = FIRStorage.storage().reference().child("InjuryPictures/\(uid)/\(ticks).jpg")
            }
            
            let uploadTask = storageRef.put(uploadData, metadata: newMetadata) { snapshot, error in
                if let error = error {
                    print(error)
                }
            }
            
            // Shows progress bar until saved
            uploadTask.observe(.progress) { snapshot in
                uploadValue += CGFloat((snapshot.progress?.fractionCompleted)!)*step
                uploadValue = uploadValue > 100 ? 100: uploadValue
                progressRing.setProgress(value: uploadValue, animationDuration: 1.0)
            }
            
            uploadTask.observe(.success) { snapshot in
                if let profileImageURL = snapshot.metadata?.downloadURL()?.absoluteString {
                    completedUploading += 1;
                    self.injuredPhoto2 = "<a href=" + profileImageURL + ">VIEW PHOTO</a><br>"
                    if completedUploading == self.imgCount {
                        progressRing.removeFromSuperview()
                        progressRing.isHidden = true
                        self.submit()
                    }
                }
            }
        }
        
        //uploading image6
        if imageView6.image != nil, let uploadData = UIImageJPEGRepresentation(imageView6.image!, 0.5) {
            
            if let uid = currentUser?.uid {
                let ticks = Date().ticks
                storageRef = FIRStorage.storage().reference().child("InjuryPictures/\(uid)/\(ticks).jpg")
            }
            
            let uploadTask = storageRef.put(uploadData, metadata: newMetadata) { snapshot, error in
                if let error = error {
                    print(error)
                }
            }
            
            // Shows progress bar until saved
            uploadTask.observe(.progress) { snapshot in
                uploadValue += CGFloat((snapshot.progress?.fractionCompleted)!)*step
                uploadValue = uploadValue > 100 ? 100: uploadValue
                progressRing.setProgress(value: uploadValue, animationDuration: 1.0)
            }
            
            uploadTask.observe(.success) { snapshot in
                if let profileImageURL = snapshot.metadata?.downloadURL()?.absoluteString {
                    completedUploading += 1;
                    self.policePhoto = "<a href=" + profileImageURL + ">VIEW PHOTO</a><br>"
                    if completedUploading == self.imgCount {
                        progressRing.removeFromSuperview()
                        progressRing.isHidden = true
                        self.submit()
                    }
                }
            }
        }

    }
    
    func submit() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["phil@hlaw.org", "lisa@hlaw.org", "kim@hlaw.org", "jeff@hlaw.org"])
        composeVC.setSubject("New Injury Report")
        
        var strReport: String = "<b>Location*:</b><br>" + "<a href=https://www.google.com/maps?q=" + strLatitude + "," + strLongitue + ">VIEW MAP</a><br>"
        strReport += "<b>Date*:</b><br>" + self.dateField.text! + "<br>"
        strReport += "<b>Time*:</b><br>" + self.timeField.text! + "<br>"
        
        strReport += "<b>Your Name*:</b><br>" + self.yourName.text! + "<br>"
        strReport += "<b>Your Phone*:</b><br>" + self.yourPhone.text! + "<br>"
        strReport += "<b>Your Address*:</b><br>" + self.yourAddress.text! + "<br>"
        strReport += "<b>Your License Plate*:</b><br>" + self.yourLicense.text! + "<br><br>"
        
        strReport += "<b>1st Accident Photo*:</b><br>" + accidentPhoto1 + "<br>"
        strReport += "<b>2nd Accident Photo*:</b><br>" + accidentPhoto2 + "<br>"
        strReport += "<b>3rd Accident Photo*:</b><br>" + accidentPhoto3 + "<br><br>"
        
        strReport += "<b>-Other Driver's Information</b><br><br>"
        strReport += "<b>Other Driver's Name:</b><br>" + self.driverName.text! + "<br>"
        strReport += "<b>Other Driver's Phone Number:</b><br>" + self.driverPhone.text! + "<br>"
        strReport += "<b>Other Driver's License Plate:</b><br>" + self.driverLicense.text! + "<br>"
        strReport += "<b>Vehicle Make/Model:</b><br>" + self.vehicleModel.text! + "<br>"
        strReport += "<b>Insurance Company:</b><br>" + self.insuranceCompany.text! + "<br><br>"
        
        strReport += "<b>-Witness Information</b><br><br>"
        strReport += "<b>Witness 1 Name:</b><br>" + self.witnessName1.text! + "<br>"
        strReport += "<b>Witness 1 Phone Number:</b><br>" + self.witnessPhone1.text! + "<br>"
        strReport += "<b>Witness 2 Name:</b><br>" + self.witnessName2.text! + "<br>"
        strReport += "<b>Witness 2 Phone Number:</b><br>" + self.witnessPhone2.text! + "<br><br>"
        
        strReport += "<b>-Injured Information</b><br><br>"
        strReport += "<b>Injured 1 Name:</b><br>" + self.injuredName1.text! + "<br>"
        strReport += "<b>Injured 1 Phone Number:</b><br>" + self.injuredPhone1.text! + "<br>"
        strReport += "<b>Injured 1 Photo*:</b><br>" + injuredPhoto1 + "<br>"
        
        strReport += "<b>Injured 2 Name:</b><br>" + self.injuredName2.text! + "<br>"
        strReport += "<b>Injured 2 Phone Number:</b><br>" + self.injuredPhone2.text! + "<br>"
        strReport += "<b>Injured 2 Photo*:</b><br>" + injuredPhoto2 + "<br>"
        
        strReport += "<b>-Police Information</b><br><br>"
        strReport += "<b>Police Name:</b><br>" + self.policeName.text! + "<br>"
        strReport += "<b>Police Number:</b><br>" + self.policeNumber.text! + "<br>"
        strReport += "<b>Police Report Number:</b><br>" + self.policeReportNumber.text! + "<br>"
        strReport += "<b>Police Photo*:</b><br>" + policePhoto + "<br>"
        
        
        
        composeVC.setMessageBody(strReport, isHTML: true)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    @IBAction func submitReport() {
        view.endEditing(true)
        
        
        if !MFMailComposeViewController.canSendMail() {
            showToast(string: "Mail services are not available.")
            print("Mail services are not available")
            return
        }
        
        if self.locationField.text == "" {
            showToast(string: "Location* required.")
            return
        }
        
        if self.dateField.text == "" {
            showToast(string: "Date* required.")
            return
        }
        
        if self.timeField.text == "" {
            showToast(string: "Time* required.")
            return
        }
        
        if self.yourName.text == "" {
            showToast(string: "Your Name* required.")
            return
        }
        
        if self.yourPhone.text == "" {
            showToast(string: "Your Phone Number* required.")
            return
        }
        
        if self.yourAddress.text == "" {
            showToast(string: "Your Address* required.")
            return
        }
        
        if self.yourLicense.text == "" {
            showToast(string: "Your License Plate* required.")
            return
        }
        
        if imageView1.image == nil {
            showToast(string: "1st Accident Photo* required.")
            return
        }
        
        if imageView2.image == nil {
            showToast(string: "2nd Accident Photo* required.")
            return
        }
        
        if imageView3.image == nil {
            showToast(string: "3rd Accident Photo* required.")
            return
        }
        
        uploadingPhotos()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
        
        FIRAnalytics.logEvent(withName: "New Accident Report Sent", parameters: [
            "name": "New Accident Report Sent" as NSObject,
            "full_text": "User sent New Accident Report" as NSObject
            ])
    }
}


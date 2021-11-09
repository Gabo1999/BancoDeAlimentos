//
//  NewDonationView.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 22/10/21.
//

import SwiftUI
import UIKit
import FirebaseStorage
import CoreImage.CIFilterBuiltins
import MLKitBarcodeScanning
import MLKitVision
import CodeScanner
import ToastUI

enum ActiveSheet: Identifiable {
    case first, second, third
    
    var id: Int {
        hashValue
    }
}

struct NewDonationView: View {
    
    let possiblePoints = ["10", "20", "30", "40", "50", "60", "70", "80", "90", "100"]
    @State private var id: String = ""
    @State private var descriptionToGive: String = ""
    @State private var titleToGive: String = ""
    @State private var pointsToGive: String = ""
    @State private var qrText: String = ""
    @State private var showQR: Bool = false
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    // Analyzing image
    @State private var description: String = ""
    @State private var points: String = ""
    @State private var qrId: String = ""
    @State private var title: String = ""
    @State private var idTest: String = ""
    @State private var showingImagePicker = false
    @State private var showingCameraScanner = false
    @State private var showingImagePickerDonation = false
    @State private var showToast = false
    //@State private var showingScanner = false
    @State var type: UIImagePickerController.SourceType = .camera
    @State var data: Data = .init(count: 0)
    @State private var showingView: ActiveSheet?
    @State private var inputImage: UIImage?
    @State private var inputImage2: UIImage?
    @State private var image: Image?
    @State private var imageDonation: Image?
    @State private var finishedDefiningUser = false
    @State private var typeUser = "Student"
    let barcodeOptions = BarcodeScannerOptions(formats: BarcodeFormat.qrCode)
    @State private var function: (() -> Void)?
    
    var body: some View {
        VStack {
            if finishedDefiningUser {
                if typeUser == "Administrator" {
                    administratorSection
                }
                else {
                    if imageDonation != nil {
                        imageDonation?
                            .resizable()
                            .scaledToFit()
                    }
                    if title != "" {
                        Text(title)
                    }
                    if qrId != "" {
                        Text(qrId)
                    }
                    if points != "" {
                        Text(points)
                    }
                    HStack {
                        Button(action: {
                            function = readQrCode
                            //self.showingImagePicker = true
                            self.showingView = .first
                        }) {
                            Text("From Library")
                        }
                        Button(action: {
                            function = readQrCode
                            //self.showingCameraScanner = true
                            self.showingView = .second
                        }) {
                            Text("From Camera")
                        }
                        Button(action: {
                            idTest = DonationViewModel.shared.db.collection("Donations").document().documentID
                            print(idTest)
                        }) {
                            Text("Generate ID")
                        }
                    }
                    HStack {
                        Button(action: {
                            type = .photoLibrary
                            function = loadImage
                            //self.showingImagePickerDonation = true
                            self.showingView = .third
                        }) {
                            Text("Front Picture (Library)")
                        }
                        Button(action: {
                            type = .camera
                            function = loadImage
                           // self.showingImagePickerDonation = true
                            self.showingView = .third
                        }) {
                            Text("Front Picture (Camera)")
                        }
                    }
                    if title != "" && qrId != "" && points != "" && description != "" && imageDonation != nil {
                        Button(action: {
                            uploadDonation(id: qrId, points: Int(points)!, title: title, description: description)
                        }) {
                            Text("Add new donation")
                        }
                    }
                }
            }
        }
        .onAppear {
            getUserType { result in
                typeUser = result
                finishedDefiningUser = true
            }
        }
        .navigationBarTitle("Nueva Donación")
        .sheet(item: $showingView, onDismiss: function) { item in
            switch item {
            case .first:
                ImagePicker(sourceType: .photoLibrary, image: self.$inputImage)
            case .second:
                CodeScannerView(codeTypes: [.qr], simulatedData: "sdflkajsñdfljdhz\n70", completion: self.handleScan)
            case .third:
                ImagePicker(sourceType: type, image: self.$inputImage2)
            }
        }
        .toast(isPresented: $showToast, dismissAfter: 2.0) {
            ToastView("Donation already registered")
        }
    }
    
    private var administratorSection: some View {
        Section(header: Text("Donation")) {
            TextField("Donation Title", text: $titleToGive)
                    .font(.title)
            TextField("Description", text: $descriptionToGive)
                .font(.body)
            Picker("Points", selection: $pointsToGive) {
                ForEach(possiblePoints, id: \.self) {
                    Text($0)
                }
            }
            if showQR {
                Image(uiImage: generateQRCode(from: qrText))
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
            }
            if titleToGive != "" && pointsToGive != "" && descriptionToGive != "" {
                Button(action: {
                    idTest = DonationViewModel.shared.db.collection("Donations").document().documentID
                    qrText = "\(idTest)\n\(pointsToGive)\n\(titleToGive)\n\(description)"
                    showQR = true
                }) {
                    Text("Generate QR")
                }
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        switch result {
        case .success(let code):
            let newDonation = code.components(separatedBy: "\n")
            guard newDonation.count == 4 else { return }
            
            qrId = newDonation[0]
            points = newDonation[1]
            title = newDonation[2]
            description = newDonation[3]
        case .failure(let error):
            print("Scanning failed:")
            print(error)
        }
    }
    
    func loadImage() {
        guard let inputImage2 = inputImage2 else { return }
        imageDonation = Image(uiImage: inputImage2)
    }
    
    func readQrCode() {
        print("Reading code")
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        let imageToScan = VisionImage(image: inputImage)
        imageToScan.orientation = inputImage.imageOrientation
        let barcodeScanner = BarcodeScanner.barcodeScanner(options: barcodeOptions)
        barcodeScanner.process(imageToScan) { features, error in
            guard error == nil, let features = features, !features.isEmpty else {
                print("Error")
                return
            }
            for barcode in features {
                let strConverted = String(decoding: barcode.rawData!, as: UTF8.self)
                print("FqakPUGxmZJEGfOsbh\n52\nDonación Prueba\nEsta es una prueba de QR" == strConverted)
                print(strConverted)
                let newDonation = strConverted.components(separatedBy: "\\n")
                print(newDonation.count)
                print(newDonation)
                guard newDonation.count == 4 else {
                    print(newDonation.count)
                    return
                }
                qrId = newDonation[0]
                points = newDonation[1]
                title = newDonation[2]
                description = newDonation[3]
            }
            
        }
    }
    
    func uploadDonation(id: String, points: Int, title: String, description: String) {
        documentExists(collection: "Donations", id: id) { (exists) in
            if !exists {
                var pictureURL = "https://firebasestorage.googleapis.com/v0/b/bancodealimentos-9473b.appspot.com/o/img_alimento-energia-hd-1024x675.jpg?alt=media&token=3b3c0d94-40ae-47bc-b898-ec62dcb8c69c"
                uploadPicture() { (url) in
                    pictureURL = url
                    let donation = DonationModel(id: id, title: title, picture: pictureURL, date: Date(), points: points, user: APIService.shared.auth.currentUser?.uid ?? "", description: description)
                    do {
                        try DonationViewModel.shared.db.collection("Donations").document(id).setData(from: donation)
                    } catch let error {
                        print("Error writing donation to Firestore: \(error)")
                    }
                }
            } else {
                showToast = true
            }
        }
    }
    
    func uploadPicture(completion: @escaping (String) -> Void) {
        var pictureURL = "https://firebasestorage.googleapis.com/v0/b/bancodealimentos-9473b.appspot.com/o/img_alimento-energia-hd-1024x675.jpg?alt=media&token=3b3c0d94-40ae-47bc-b898-ec62dcb8c69c"
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("DonationsImages/image.jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        guard let imageData = inputImage2?.jpegData(compressionQuality: 0.5)  else {
            print("No PNG")
            completion(pictureURL)
            return
        }
        _ = imagesRef.putData(imageData, metadata: metadata) { (metadata, error) in
            guard metadata != nil else {
                print("Empty Metadata")
                completion(pictureURL)
                return
            }
            imagesRef.downloadURL { (url, error) in
                guard url != nil else {
                    print("Empty URL: \(String(describing: error))")
                    completion(pictureURL)
                    return
                }
                pictureURL = url!.absoluteString
                completion(pictureURL)
            }
        }
        completion(pictureURL)
    }
    
    func getUserType(completion: @escaping (String) -> Void) {
        let docRef = DonationViewModel.shared.db.collection("Users").document(APIService.shared.auth.currentUser!.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("userType") as! String)
            } else {
                completion("Student")
            }
        }
        completion("Student")
    }
    
    
    func documentExists(collection: String, id: String, completion: @escaping (Bool) -> Void){
        let docRef = DonationViewModel.shared.db.collection(collection).document(id)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
        completion(false)
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
            
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct NewDonationView_Previews: PreviewProvider {
    static var previews: some View {
        NewDonationView()
    }
}

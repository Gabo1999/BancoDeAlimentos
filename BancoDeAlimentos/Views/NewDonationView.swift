//
//  NewDonationView.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 22/10/21.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import MLKitBarcodeScanning
import MLKitVision
import CodeScanner

struct NewDonationView: View {
    
    @State private var id = "Q165465dasdfe5E4S6S5d5g4df6"
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    // Analyzing image
    @State private var rawData: String = ""
    @State private var points: String = ""
    @State private var qrId: String = ""
    @State private var showingImagePicker = false
    //@State private var showingScanner = false
    @State var type: UIImagePickerController.SourceType = .camera
    @State var data: Data = .init(count: 0)
    @State private var inputImage: UIImage?
    @State private var image: Image?
    let barcodeOptions = BarcodeScannerOptions(formats: BarcodeFormat.qrCode)
    
    var body: some View {
        // Generating QR code
//        VStack {
//            TextField("ID de Donación", text: $id)
//                .font(.title)
//            Image(uiImage: generateQRCode(from: id))
//                .interpolation(.none)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 200, height: 200)
//        }
        VStack {
            if image != nil {
                image?
                    .resizable()
                    .scaledToFit()
            }
            if rawData != "" {
                Text(rawData)
            }
            if qrId != "" {
                Text(qrId)
            }
            if points != "" {
                Text(points)
            }
            HStack {
                Button(action: {
                    self.type = .photoLibrary
                    self.showingImagePicker = true
                }) {
                    Text("From Library")
                }
                Button(action: {
                    self.type = .camera
                    self.showingImagePicker = true
                }) {
                    Text("From Camera")
                }
            }
        }
        .navigationBarTitle("Nueva Donación")
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            if type == .photoLibrary {
                ImagePicker(image: self.$inputImage)
            } else {
                CodeScannerView(codeTypes: [.qr], simulatedData: "sdflkajsñdfljdhz\n70", completion: self.handleScan)
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.showingImagePicker = false
        
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            qrId = details[0]
            points = details[1]
        case .failure(let error):
            print("Scanning failed:")
            print(error)
        }
    }
    
    func loadImage() {
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
                rawData = barcode.rawValue!
            }
            
        }
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

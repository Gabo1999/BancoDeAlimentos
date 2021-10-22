//
//  NewDonationView.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 22/10/21.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct NewDonationView: View {
    
    @State private var id = "Q165465dasdfe5E4S6S5d5g4df6"
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        VStack {
            TextField("ID de Donación", text: $id)
                .font(.title)
            Image(uiImage: generateQRCode(from: id))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
        .navigationBarTitle("Nueva Donación")
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

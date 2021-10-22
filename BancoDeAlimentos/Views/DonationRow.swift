//
//  DonationRow.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 21/10/21.
//

import SwiftUI
import Kingfisher

struct DonationRow: View {
    
    var donation: DonationModel
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Text(donation.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Menu(content: {
                    Text("Edit")
                    
                }, label: {
                    Image("menu")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.white)
                })
            }
            if donation.picture != "" {
                KFImage(URL(string: donation.picture))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 60, height: 200)
                    .cornerRadius(15)
            }
            HStack {
                Text("Points: \(donation.points)")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer(minLength: 0)
            }
        }
        .padding()
        .background(Color.white.opacity(0.06))
        .cornerRadius(15)
    }
}

struct DonationRow_Previews: PreviewProvider {
    static var previews: some View {
        DonationRow(donation: DonationModel.dummy)
    }
}

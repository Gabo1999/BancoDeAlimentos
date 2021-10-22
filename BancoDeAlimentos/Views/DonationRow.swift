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
    
    var dateFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM/yyyy"
        return formatter
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(donation.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer(minLength: 0)
                Menu(content: {
                    Text("Edit")
                    
                }, label: {
                    Image(systemName: "ellipsis")
                        .renderingMode(.template)
                        .foregroundColor(.black)
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
                Text("Puntos: \(donation.points)")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer(minLength: 0)
                Text("Fecha de donación: \(dateFormat.string(from: donation.date))")
                Spacer(minLength: 0)
            }
            Spacer()
        }
        .padding(10)
        .background(Color.orange.opacity(0.2))
        .cornerRadius(15)
    }
}

struct DonationRow_Previews: PreviewProvider {
    static var previews: some View {
        DonationRow(donation: DonationModel.dummy)
    }
}

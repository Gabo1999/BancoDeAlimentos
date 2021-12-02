//
//  DonationsDetailView.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 01/12/21.
//

import SwiftUI
import Kingfisher

struct DonationsDetailView: View {
    var donation: DonationModel
    
    var dateFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM/yyyy"
        return formatter
    }
    
    var body: some View {
        ZStack {
            Color("CaritasColorSecundario").edgesIgnoringSafeArea(.all)
            VStack {
                Text(donation.title)
                    .bold()
                    .font(.custom("TT Commons Bold.otf", size: 15))
                if donation.picture != "" {
                    KFImage(URL(string: donation.picture))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width - 30, height: 400)
                        .cornerRadius(10)
                }
                Text(donation.description)
                    .frame(width: UIScreen.main.bounds.width - 30, alignment: .leading)
                    .padding(.bottom, 10)
                    .font(.custom("NeueHaasUnicaPro-Black.tff", size: 15))
                HStack {
                    Text("Puntos: \(donation.points)")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .font(.custom("NeueHaasUnicaPro-Black.tff", size: 15))
                    Spacer(minLength: 0)
                    Text("Fecha de donación: \(dateFormat.string(from: donation.date))")
                        .font(.custom("NeueHaasUnicaPro-Black.tff", size: 15))
                    Spacer(minLength: 0)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 30)
        }
    Spacer()
    }
}

struct DonationsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DonationsDetailView(donation: DonationModel.dummy)
    }
}

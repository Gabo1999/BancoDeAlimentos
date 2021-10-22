//
//  DonationsView.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 21/10/21.
//

import SwiftUI

struct DonationsView: View {
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @StateObject var donationsData = DonationViewModel()
    var body: some View {
        VStack {
            HStack {
                Text("Donaciones")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    print("something")
                }, label: {
                    Image(systemName: "plus.circle")
                        .font(.title)
                        .foregroundColor(Color("blue"))
                })
            }
            .padding()
            .padding(.top, edges!.top)
            .background(Color("bg"))
            .shadow(color: Color.white.opacity(0.06), radius: 5, x: 0, y: 5)
            
            if donationsData.donations.isEmpty {
                Spacer()
                if donationsData.noDonations {
                    Text("No hay nuevas donaciones")
                } else {
                    ProgressView()
                }
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(donationsData.donations) { donation in
                            DonationRow(donation: donation)
                            
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct DonationsView_Previews: PreviewProvider {
    static var previews: some View {
        DonationsView()
    }
}

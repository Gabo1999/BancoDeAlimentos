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
//                HStack {
//                    Text("Donaciones")
//                        .font(.largeTitle)
//                        .fontWeight(.heavy)
//                        .foregroundColor(.black)
//                    Spacer(minLength: 0)
//                    Button(action: {
//                        print("something")
//                    }, label: {
//                        Image(systemName: "plus.circle")
//                            .font(.title)
//                            .foregroundColor(Color(.black))
//                    })
//                }
//                .padding()
//                .padding(.top,edges!.top)
//                .background(Color(.green))
//                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            //.ignoresSafeArea(.all, edges: .top)
            
            if donationsData.donations.isEmpty {
                Spacer(minLength: 0)
                if donationsData.noDonations {
                    Text("No hay nuevas donaciones")
                } else {
                    ProgressView()
                }
                Spacer(minLength: 0)
            } else {
                ScrollView {
                    VStack {
                        ForEach(donationsData.donations) { donation in
                            DonationRow(donation: donation)
                        }
                        .padding(.bottom, 10)
                    }
                    .padding()
                }
            }
            Spacer()
        }
    }
}

struct DonationsView_Previews: PreviewProvider {
    static var previews: some View {
        DonationsView()
    }
}

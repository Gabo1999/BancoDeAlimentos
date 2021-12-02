//
//  DonationsView.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 21/10/21.
//

import SwiftUI

struct SlideMenu : View {
    
    @ObservedObject var donationsData: DonationViewModel
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var loginModel: LoginModel
    @State private var showMenuDrop = true
    @State private var isShowingTrophies = false
    @State private var isShowingNewDonations = false
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading) {
                Image("caritasArtboard 8 copy")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("\(donationsData.currentUser.userName)")
                            .font(.custom("TT Commons Bold.otf", size: 15))
                        HStack(spacing: 20) {
                            StatsView(counter: donationsData.currentUser.score, title: "Game Score")
                                .onTapGesture {
                                    
                                }
                            StatsView(counter: donationsData.currentUser.energy, title: "Energy")
                                .onTapGesture {
                                    
                                }
                        }
                        .padding(.top, 10)
                        Divider()
                            .padding(.top)
                    }
                    Spacer(minLength: 0)
                    Button(action: {
                        withAnimation {
                            showMenuDrop.toggle()
                        }
                    }) {
                        Image(systemName: showMenuDrop ? "chevron.down" : "chevron.up")
                            .foregroundColor(Color.orange)
                    }
                }
                VStack(alignment: .leading) {
                    NavigationLink(destination: TrophiesView()) {
                        MenuButton(title: "Trophies")
                    }
                    NavigationLink(destination: NewDonationView(donationsData: donationsData)) {
                        MenuButton(title: "New Donation")
                    }
                    Button(action: {
                        loginModel.signOut { result in
                            print(result)
                            authentication.updateValidation(success: !result, firstTime: false)
                        }
                    }) {
                        MenuButton(title: "Sign Out")
                    }
                    Divider()
                        .padding(.top)
                    Button(action: {
                        
                    }) {
                        MenuButton(title: "Settings and Privacy")
                    }
                    Divider()
                    Button(action: {
                        
                    }) {
                        Text("Help centre")
                            .font(.custom("NeueHaasUnicaPro-Black.tff", size: 15))
                    }
                    .padding(.top)
                }
                .opacity(showMenuDrop ? 1: 0)
                .frame(height: showMenuDrop ? nil : 0)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 130)
            .frame(width: UIScreen.main.bounds.width - 90, height: UIScreen.main.bounds.height)
            .background(Color.white)
            //.ignoresSafeArea(.all, edges: .vertical)
            Spacer(minLength: 0)
        }
    }
}

struct MenuButton: View {
    var title: String
    var body: some View {
        HStack(spacing: 15) {
            Image(title)
                .resizable()
                .renderingMode(.template)
                .frame(width: 24, height: 24)
                .foregroundColor(.gray)
            Text(title)
                .foregroundColor(.black)
                .font(.custom("NeueHaasUnicaPro-Black.tff", size: 15))
            Spacer(minLength: 0)
        }
        .padding(.vertical, 12)
    }
}

struct StatsView: View {
    var counter: Int
    var title: String
    
    var body: some View {
        HStack {
            Text("\(counter)")
                .fontWeight(.bold)
                .foregroundColor(.black)
                .font(.custom("NeueHaasUnicaPro-Black.tff", size: 15))
            Text(title)
                .foregroundColor(.gray)
                .font(.custom("NeueHaasUnicaPro-Black.tff", size: 15))
        }
    }
}

struct MenuPage: View {
    @ObservedObject var donationsData: DonationViewModel
    @State private var width = UIScreen.main.bounds.width - 90
    @Binding var x: CGFloat
    var body: some View  {
        ZStack {
            Color("CaritasColorSecundario").edgesIgnoringSafeArea(.all)
            Home(donationsData: donationsData)
            SlideMenu(donationsData: donationsData)
                .shadow(color: Color.black.opacity(x != 0 ? 0.1 : 0), radius: 5, x: 5, y: 0)
                .offset(x: x)
                .background(Color.black.opacity(x == 0 ? 0.5 : 0).ignoresSafeArea(.all, edges: .vertical).onTapGesture {
                        withAnimation {
                            x = -width
                        }
                })
        }
        .gesture(DragGesture().onChanged({ (value) in
            withAnimation {
                if value.translation.width > 0 {
                    if x < 0 {
                        x = -width + value.translation.width
                    }
                } else {
                    x = value.translation.width
                }
            }
        }).onEnded({ (value) in
            withAnimation {
                if -x < width / 2 {
                    x = 0
                } else {
                    x = -width
                }
            }
        }))
    }
}

struct Home: View {
    @ObservedObject var donationsData: DonationViewModel
    var body: some View {
        VStack {
            if donationsData.donations.isEmpty {
                Spacer(minLength: 0)
                if donationsData.noDonations {
                    Text("No hay nuevas donaciones")
                        .font(.custom("TT Commons Bold.otf", size: 15))
                } else {
                    ProgressView()
                }
                Spacer(minLength: 0)
            } else {
                ScrollView {
                    VStack {
                        ForEach(donationsData.donations) { donation in
                            NavigationLink(destination: DonationsDetailView(donation: donation)) {
                                DonationRow(donation: donation)
                            }
                        }
                        .padding(.bottom, 10)
                    }
                }
                .padding(.top, 130)
            }
            Spacer()
        }
    }
}

struct DonationsView: View {
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @StateObject var donationsData = DonationViewModel()
    @Binding var x: CGFloat
    var body: some View {
        MenuPage(donationsData: donationsData, x: $x)
            .onAppear{
                donationsData.getEverything()
            }
    }
}


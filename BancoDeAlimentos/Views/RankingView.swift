//
//  RankingView.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 01/12/21.
//

import SwiftUI

struct RankingView: View {
    @StateObject var rankingData = RankingModel()
    var body: some View {
        ZStack {
            Color("CaritasColorSecundario").edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text("Your stats!")
                    .bold()
                    .font(.system(size: 20))
                    .padding(.top, 20)
                    .font(.custom("TT Commons Bold.otf", size: 15))
                HStack {
                    Image("caritasArtboard 8 copy")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    Text(rankingData.currentUser.userName)
                        .bold()
                        .font(.custom("TT Commons Bold.otf", size: 15))
                    Text("\(rankingData.currentUser.score) points")
                        .font(.custom("NeueHaasUnicaPro-Black.tff", size: 15))
                }
                .padding(.bottom, 20)
                if !rankingData.noUsers {
                    Text("Top \(rankingData.topTenUsers.count) players")
                        .bold()
                    Divider()
                        .padding(.bottom, 10)
                    ForEach(rankingData.topTenUsers.indices, id: \.self) { index in
                        HStack {
                            Text("\(index + 1)")
                                .font(.custom("NeueHaasUnicaPro-Black.tff", size: 15))
                            Image("caritasArtboard 8 copy")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                            Text(rankingData.topTenUsers[index].userName)
                                .bold()
                                .font(.custom("TT Commons Bold", size: 15))
                            Text("\(rankingData.topTenUsers[index].score) points")
                                .font(.custom("NeueHaasUnicaPro-Black.tff", size: 15))
                        }
                        .padding(.top, 20)
                    }
                } else {
                    Divider()
                    Text("No ranked users yet")
                        .font(.custom("TT Commons Bold.otf", size: 15))
                }
                Spacer()
            }
            .frame(width: 350)
        }
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView()
    }
}

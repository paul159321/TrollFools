//
//  OptionCell.swift
//  TrollFools
//
//  Created by 82Flex on 2024/10/30.
//

import SwiftUI

struct OptionCell: View {
    let option: Option

    var iconName: String {
        if #available(iOS 16.0, *) {
            if option == .attach {
                return "syringe"
            } else if option == .favorite {
                return isFavorite ? "heart.fill" : "heart"
            } else {
                return "xmark.bin"
            }
        } else {
            if option == .attach {
                return "tray.and.arrow.down"
            } else if option == .favorite {
                return isFavorite ? "heart.fill" : "heart"
            } else {
                return "xmark.bin"
            }
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .foregroundColor(option == .attach ? .accentColor : option == .favorite ? .yellow : .red)
                .padding(.all, 40)
            }
            .background(
                (option == .attach ? Color.accentColor : option == .favorite ? Color.yellow : Color.red)
                    .opacity(0.1)
                    .clipShape(RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    ))
            )

            Text(option == .attach
                 ? NSLocalizedString("Inject", comment: "")
                 : option == .favorite
                 ? NSLocalizedString("Favorite", comment: "")
                 : NSLocalizedString("Eject", comment: ""))
                .font(.headline)
                .foregroundColor(option == .attach ? .accentColor : option == .favorite ? .yellow : .red)
        }
    }
}

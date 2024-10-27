import SwiftUI
import Foundation

private enum Option {
    case attach
    case detach
    case favorite
}

private struct OptionCell: View {
    let option: Option
    let isFavorite: Bool

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
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
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

struct OptionView: View {
    let app: App

    @EnvironmentObject var vm: AppListModel

    @State var isImporterPresented = false
    @State var isImporterSelected = false
    @State var isSettingsPresented = false
    @State var importerResult: Result<[URL], any Error>? = nil
    @State var isFavorite: Bool = false // 設定初始值為 false

    init(_ app: App) {
        self.app = app
    }
    
    var body: some View {
        VStack(spacing: 80) {
            HStack {
                Spacer()

                Button {
                    isImporterPresented = true
                } label: {
                    OptionCell(option: .attach, isFavorite: isFavorite)
                }
                .accessibilityLabel(NSLocalizedString("Inject", comment: ""))

                Spacer()

                NavigationLink {
                    EjectListView(app)
                } label: {
                    OptionCell(option: .detach, isFavorite: isFavorite)
                }
                .accessibilityLabel(NSLocalizedString("Eject", comment: ""))

                Spacer()

                Button {
                    FavoriteFun().updateFavorite(app.id)
                    isFavorite.toggle() // 更新 isFavorite
                    withAnimation {
                        app.reload()
                    }
                } label: {
                    OptionCell(option: .favorite, isFavorite: isFavorite)
                }
                .accessibilityLabel(NSLocalizedString("Favorite", comment: ""))

                Spacer()
            }

            Button {
                isSettingsPresented = true
            } label: {
                Label(NSLocalizedString("Advanced Settings", comment: ""),
                      systemImage: "gear")
            }
        }
        .padding()
        .navigationTitle(app.name)
        .onAppear {
            isFavorite = FavoriteFun().isBundleFavorite(app.id) // 在視圖出現時更新 isFavorite
        }
        .background(Group {
            NavigationLink(isActive: $isImporterSelected) {
                if let result = importerResult {
                    switch result {
                    case .success(let urls):
                        InjectView(app, urlList: urls
                            .sorted(by: { $0.lastPathComponent < $1.lastPathComponent }))
                    case .failure(let message):
                        FailureView(title: NSLocalizedString("Error", comment: ""),
                                    message: message.localizedDescription)
                    }
                }
            } label: { }
        })
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [
                .init(filenameExtension: "dylib")!,
                .bundle,
                .framework,
                .package,
                .zip,
            ],
            allowsMultipleSelection: true
        ) {
            result in
            importerResult = result
            isImporterSelected = true
        }
        .sheet(isPresented: $isSettingsPresented) {
            if #available(iOS 16.0, *) {
                SettingsView(app)
                    .presentationDetents([.medium, .large])
            } else {
                SettingsView(app)
            }
        }
    }
}

import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel = FriendsViewModel()
    @State private var selectedTab: TabItem = .games
    @State private var isTabBarHidden = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea() // <-
            VStack{
                Group {
                    switch selectedTab {
                    case .friends: FriendsView(viewModel: viewModel)
                    case .games: GamesHubView(viewModel: viewModel, isTabBarHidden: $isTabBarHidden)
                    case .stats: StatsView(players: $viewModel.players)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if !isTabBarHidden{
                    CustomTabBar(selectedTab: $selectedTab)
                        
                }
            }
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem

    var body: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.horizontal)
        .background(Color.black.edgesIgnoringSafeArea(.bottom))
        .shadow(color: .black.opacity(0.8), radius: 4, y: -2)
    }

    @ViewBuilder
    private func tabButton(for tab: TabItem) -> some View {
        let isSelected = selectedTab == tab

        Button(action: {
            withAnimation(.easeInOut) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: .bold))
                Text(tab.rawValue)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .black : .white)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(
                isSelected ? Color.orange.cornerRadius(12) : Color.clear.cornerRadius(0)
            )
        }
    }
}


#Preview{
    MainTabView()
}

//
//  RunPreviewView.swift
//
//
//  Created by DOMINIC NDONDO on 12/8/22.
//
import SwiftUI
import ComposableArchitecture
import Configurations

public struct ConfigurationsView: View {
    public var store: StoreOf<ConfigurationsFeature>
    
    
    public init(store: StoreOf<ConfigurationsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewstore in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    // MARK - This View will contain charts and other interesting views showing how the smart motor behaves in run mode
                    Text("Config Feature.")
                        .font(.title)
                    
                    Spacer()
                }
                Spacer()
            }
          
        }
        
    }
}

struct ConfigurationsView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationsView(
            store: Store(
                initialState: ConfigurationsFeature.State(),
                reducer: ConfigurationsFeature()
            )
        )
    }
}


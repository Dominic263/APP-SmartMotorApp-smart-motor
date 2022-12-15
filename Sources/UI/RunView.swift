//
//  RunPreviewView.swift
//
//
//  Created by DOMINIC NDONDO on 12/8/22.
//
import SwiftUI
import ComposableArchitecture
import Run

public struct RunView: View {
    public var store: StoreOf<RunFeature>
    
    
    public init(store: StoreOf<RunFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewstore in
            VStack {
                Text(viewstore.title)
                    .font(.title)
                Spacer()
                HStack {
                    Spacer()
                    // MARK - This View will contain charts and other interesting views showing how the smart motor behaves in run mode
                    Text("")
                        .font(.title)
                    Spacer()
                }
                Spacer()
            }
          
        }
        
    }
}

struct RunView_Previews: PreviewProvider {
    static var previews: some View {
        RunView(
            store: Store(
                initialState: RunFeature.State(),
                reducer: RunFeature()
            )
        )
    }
}

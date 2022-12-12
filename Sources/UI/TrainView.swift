//
//  TrainView.swift
//
//
//  Created by DOMINIC NDONDO on 12/8/22.
//
import SwiftUI
import ComposableArchitecture
import Train

public struct TrainView: View {
    
    public var store: StoreOf<TrainFeature>
    
    
    public init(store: StoreOf<TrainFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewstore in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    // MARK - This View will contain charts and other interesting views showing how the smart motor behaves in run mode
                    Text("Train Feature.")
                        .font(.title)
                   
                    Spacer()
                }
                Spacer()
                
            }
          
        }
        
    }
}

struct TrainView_Previews: PreviewProvider {
    static var previews: some View {
        TrainView(
            store: Store(
                initialState: TrainFeature.State(),
                reducer: TrainFeature()
            )
        )
    }
}

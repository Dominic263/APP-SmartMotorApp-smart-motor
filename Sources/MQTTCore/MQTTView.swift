//
//  SwiftUIView.swift
//  
//
//  Created by CEEO Media Station on 12/12/22.
//

import SwiftUI
import ComposableArchitecture
import MQTTNIO


public struct MQTTView: View {
    
    public var store: StoreOf<MQTTManager>
    
    public init(store: StoreOf<MQTTManager>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewstore in
            VStack {
                Text("Connect to Client")
                
                Form {
                    
                    Section {
                        TextField("Enter Host",
                                  text: viewstore.binding(
                                    get: \.host,
                                    send: MQTTManager.Action.changeHost
                                  )
                        )
                        //.autocapitalization(.none)
                        //.autocorrectionDisabled()
                    }
                    
                    
                    
                    Section {
                        TextField("Enter Port",
                                  text: viewstore.binding(
                                    get: \.port,
                                    send: MQTTManager.Action.changePort
                                  )
                        )
                       /// .autocapitalization(.none)
                       // .autocorrectionDisabled()
                    }
                    
                    
                }
                Spacer()
                Section {
                    Text("Dialog: " + viewstore.alertString) //To be changed to a dialog box later
                }
                Spacer()
                
                Button(action: { viewstore.send(.connectToBroker)}) {
                    VStack{
                        Image(systemName: "app.connected.to.app.below.fill")
                        Text("connect")
                    }
                }
            }.autocapitalization(.none)
                .autocorrectionDisabled()
        }
    }
}


struct MQTTView_Previews: PreviewProvider {
    static var previews: some View {
        MQTTView(
            store: Store(
                initialState: MQTTManager.State(),
                reducer: MQTTManager()
            )
        )
    }
}

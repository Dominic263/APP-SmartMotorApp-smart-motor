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
                
                    Text(viewstore.title)
                        .font(.title)
                    Divider()
                    
                    Section {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "dot.radiowaves.left.and.right")
                                    .resizable()
                                    .frame(width: 20, height: 15)
                                Text("MQTT Broker Connection")
                                    .font(.headline)
                                
                                if(viewstore.isConnecting){
                                    Spacer()
                                    Spacer()
                                    ProgressView()
                                }
                                Spacer()
                            }.padding()
                           Divider()
                            
                                HStack {
                                   
                                    
                                    Button(action: {viewstore.send(.connect)}){
                                        VStack {
                                            Image(systemName: "antenna.radiowaves.left.and.right")
                                            Text("Connect")
                                                .font(.caption2)
                                        }
                                    }
                                    .disabled(viewstore.connected)
                                    .padding()
                                    
                                    Spacer()
                                    Button(action: {viewstore.send(.disconnect)}){
                                        VStack {
                                            Image(systemName: "antenna.radiowaves.left.and.right.slash")
                                            Text("Disconnect")
                                                .font(.caption2)
                                        }
                                    }
                                    .disabled(!viewstore.connected)
                                    Spacer()
                                    VStack{
                                        Text(viewstore.connectionStatus)
                                        Circle()
                                            .frame(width:10, height: 10)
                                            .foregroundColor(viewstore.connectColor)
                                    }
                                    Spacer()
                                    
                                    
                                }
                            
                        }
                        .background(Color.mint.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                    }
                    Spacer()
                    // MARK - This View will contain charts and other interesting views showing how the smart motor behaves in run mode
                    Divider()
                    Section {
                        VStack {
                            Text(viewstore.info)
                                .padding()
                        }
                        
                    }
                    .background(Color.mint.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    Divider()
                    Section {
                        VStack {
                            
                            HStack {
                                Image(systemName: "bell")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Subscribe To topics")
                                    .font(.headline)
                                Spacer()
                            }.padding()
                            Divider()
                            //VIEW - Displays TextField For Topics To Connect To
                            HStack {
                                Spacer()
                                
                                
                                TextField("Enter Topic",
                                          text: viewstore.binding(
                                            get: \.topic,
                                            send: TrainFeature.Action.topicChanged
                                        )
                                )
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                
                                
                                
                                .background(Color.gray.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .padding(0.5)
                                
                                Button(action: {viewstore.send(.subscribeTapped)}){
                                    VStack {
                                        Image(systemName: "bell.fill")
                                        Text("Subscribe")
                                            .font(.caption2)
                                    }
                                    .frame(width: 60, height: 5)
                                    .padding()
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 2))
                                Spacer()
                            }.padding()
                        }
                        .background(Color.mint.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                    }
                
               
                Section {
                    VStack {
                        List {
                            ForEach(viewstore.topics, id: \.self){ topic in
                                Section {
                                    Text(topic)
                                        .padding()
                                }
                            }
                            
                        }
                    }
                }
                
                Text("actions: \(viewstore.dialog)")
                
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

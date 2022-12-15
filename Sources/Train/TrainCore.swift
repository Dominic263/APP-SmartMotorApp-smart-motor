//
//  File.swift
//  
//
//  Created by DOMINIC NDONDO on 12/8/22.
//


import Foundation
import ComposableArchitecture
import SwiftUI
import MQTTCore

public struct TrainFeature: ReducerProtocol {
    public init() {}
    
    public struct State: Equatable {
        public var topics: [String] = []
        public var topic: String
        public var dialog: String = ""
        public var MQTTState: MQTTManager.State = .init()
        public var title: String = "Train"
        public var connectColor: Color = .red
        public var connectionStatus: String = "disconnected"
        public var connected: Bool = false
        public var isConnecting: Bool = false
        public var info: String  = """
        In order to start training your model you need to connect to different topics on your broker.\
        If any changes happen in real time on the broker, you will be able to see these changes in \
        realtime.
        """
        public init(topic: String = "") {
            self.topic = topic
        }
    }
    
    public enum Action: Equatable {
        case connectionComplete
        case MQTTAction(MQTTManager.Action)
        case connect
        case disconnect
        case sendingConnection
        case sendingDisconnection
        case disconnectionComplete
        case topicChanged(String)
        case subscribeTapped
    }
    
    
    
    public var body: some ReducerProtocol<State, Action> {
        
        Reduce { state, action in
            switch action {
            case .connect:
                state.dialog = "action: connect"
                state.isConnecting = true
                return .task {
                    try await Task.sleep(for: .seconds(3))
                    return .sendingConnection
                }
                
            case .topicChanged(let topic):
                state.topic = topic
                return .none
                
            case .connectionComplete:
                state.dialog = "action:: checking completeness of connection"
                if(state.MQTTState.client?.isConnected == true) {
                    state.isConnecting = false
                    state.connected = true
                    state.connectColor = .green
                    state.connectionStatus = "connected"
                    return .none
                }
                state.dialog = "connection failed"
                state.isConnecting = false
                return .none
            
            case .MQTTAction(.connectToBroker):
                state.dialog = "action: mqtt action -> .connect to broker"
                
                return .task {
                    try await Task.sleep(for: .seconds(4))
                    return .connectionComplete
                }
            case .disconnect:
                state.isConnecting = true
                return .task {
                    try await Task.sleep(for: .seconds(3))
                    return .sendingDisconnection
                }
            case .sendingDisconnection:
                return .task {
                    return .MQTTAction(.disconnectFromBroker)
                }
                
                
            case .MQTTAction(.subscribeToTopic(_)):
                return .none
            case .MQTTAction(.publishToTopic(_)):
                return .none
            case .MQTTAction(.disconnectFromBroker):
                return .task {
                    try await Task.sleep(for: .seconds(4))
                    return .disconnectionComplete
                }
            case .disconnectionComplete:
                state.dialog = "action:: checking completeness of disconnection"
                if(state.MQTTState.client?.isConnected == false) {
                    state.isConnecting = false
                    state.connected = false
                    state.connectColor = .red
                    state.connectionStatus = "disconnected"
                    return .none
                }
                state.dialog = "disconnection failed"
                state.isConnecting = false
                return .none
                
            case .MQTTAction(.changePort(_)):
                return .none
            case .MQTTAction(.changeHost(_)):
                return .none
            case .MQTTAction(.finishConnecting):
                return .none
            case .sendingConnection:
                state.dialog = "Sending connection."
                return .task {
                    try await Task.sleep(for: .seconds(2))
                    return .MQTTAction(.connectToBroker)
                }
            case .subscribeTapped:
                state.topics.append(state.topic)
                return .task { [state] in
                    try await Task.sleep(for: .seconds(3))
                    return .MQTTAction(.subscribeToTopic(state.topic))
                }
            }
        }
        
        Scope(state: \.MQTTState, action: /TrainFeature.Action.MQTTAction) {
            MQTTManager()
        }
    }
}

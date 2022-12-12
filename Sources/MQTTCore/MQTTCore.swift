//
//  MQTTCore.swift
//  
//
//  Created by DOMINIC NDONDO on 12/8/22.
//
// MARK - This file has all the necessary configurations to initialize an
//        MQTT client

import Foundation
import ComposableArchitecture
import MQTTNIO

extension MQTTClient: Equatable  {
    public static func == (lhs: MQTTNIO.MQTTClient, rhs: MQTTNIO.MQTTClient) -> Bool {
        return lhs.host == rhs.host && lhs.port == rhs.port
    }
    
}

public struct MQTTManager: ReducerProtocol {
    public init() {}
    public struct State: Equatable {
        public var client: MQTTClient? = nil
        public var isConnected: Bool
        public var isConnecting: Bool
        public var host: String
        public var port: String
        
        public init(client: MQTTClient? = nil, isConnected: Bool = false, isConnecting: Bool = false, host: String = "", port: String = "") {
            self.client = client
            self.isConnected = isConnected
            self.isConnecting = isConnecting
            self.host = host
            self.port = port
        }
        
    }
    
    public enum Action: Equatable {
        case connectToBroker
        case subscribeToTopic(String)
        case publishToTopic(String)
        case disconnectFromBroker
        case changePort(String)
        case changeHost(String)
        case finishConnecting
        case validateConnection(Bool?)
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .connectToBroker:
            state.isConnecting = true
            state.client = MQTTClient(
                host: "mqtt.eclipse.org",
                port: 1883,
                identifier: "My Client",
                eventLoopGroupProvider: .createNew
            )
            
            return .none
        case .subscribeToTopic(_):
            return .none
        case .publishToTopic(_):
            return .none
        case .disconnectFromBroker:
            return .none
        case .changePort( let newPort):
            state.port = newPort
            return .none
        case .changeHost(let newHost):
            state.host = newHost
            return .none
        case .finishConnecting:
            
            var clientConnection: Bool?
            
            return .task { [client = state.client] in
               var clientConnection = try await client?.connect()
                    .map(.validateConnection(clientConnection))
            }
                    
            
        case .validateConnection(let bool):
            if bool == true {
                print("Connected Successfully.")
            }else {
                print("Connection Error.")
            }
        }
    }
}

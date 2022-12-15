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
        return lhs.configuration.clientId == rhs.configuration.clientId
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
        public var alertString: String
        
        public init(client: MQTTClient? = nil, isConnected: Bool = false, isConnecting: Bool = false, host: String = "", port: String = "", alertString: String = "") {
            self.client = client
            self.isConnected = isConnected
            self.isConnecting = isConnecting
            self.host = host
            self.port = port
            self.alertString = alertString
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
        
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .connectToBroker:
            state.alertString = "preparing client ..."
            state.isConnecting = true
            
            state.client = MQTTClient(
                configuration: .init(
                    target: .host("broker.emqx.io", // will replace this functionality with the actual entered ports
                                  port:  1883
                    )
                ),
                eventLoopGroupProvider: .createNew
            )
            state.alertString = "...connecting to broker..."
            
            return .task { [state] in
                try await state.client?.connect()
                try await Task.sleep(for: .seconds(5.0))
                return .finishConnecting
            }
            
        case .subscribeToTopic(let topic):
            state.client?.subscribe(to: topic)
            return .none
        case .publishToTopic(_):
            return .none
        case .disconnectFromBroker:
            state.client?.disconnect()
            return .none
        case .changePort( let newPort):
            state.port = newPort
            return .none
        case .changeHost(let newHost):
            state.host = newHost
            return .none
        case .finishConnecting:
            state.alertString = "connecting to client ..."
            
            if (state.client?.isConnected == true){
                state.alertString = "...connected to broker at broker.emqx.io"
                
            }
            else {
                state.alertString = "... connection failure, check your host and port settings ..."
                
            }
            return .none
             
        }
    }
}

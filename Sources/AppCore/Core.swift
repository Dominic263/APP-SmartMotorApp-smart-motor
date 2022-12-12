//
//  File.swift
//  
//
//  Created by DOMINIC NDONDO on 12/8/22.
//
import ComposableArchitecture
import Foundation
import Run
import Configurations
import Train

//MARK - Tabs in the app
public enum Tab {
    case configurations
    case train
    case run
}

public struct AppFeature: ReducerProtocol {
    
    public init() {}
    
   
    public struct State: Equatable {
        
        public var selectedTab: Tab
        public var runState: RunFeature.State
        public var configState: ConfigurationsFeature.State
        public var trainState: TrainFeature.State
        
        public init(tab: Tab = .train, runState: RunFeature.State = .init(), configState: ConfigurationsFeature.State = .init(), trainState: TrainFeature.State = .init()) {
            self.selectedTab = tab
            self.runState = runState
            self.configState = configState
            self.trainState = trainState
        }
    }
    
    public enum Action: Equatable {
        case none
        case changeTab(Tab)
        case run(RunFeature.Action)
        case config(ConfigurationsFeature.Action)
        case train(TrainFeature.Action)
    }
    
    //Dependencies go here
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .none:
                return .none
            case .changeTab(let newTab):
                state.selectedTab = newTab
                return .none
            case .run( _ ):
                return .none
            case .config(_):
                return .none
             
            case .train(_):
                return .none
            }
        }
        
        // MARK - Other Reducers go here
        Scope(state: \.runState, action: /Action.run) {
            RunFeature()
        }
        Scope(state: \.configState, action: /Action.config) {
            ConfigurationsFeature()
        }
        Scope(state: \.trainState, action: /Action.train) {
            TrainFeature()
        }
    }
}

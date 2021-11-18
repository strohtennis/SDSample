//
//  ContentView.swift
//  SDWatchSample WatchKit Extension
//
//  Created by Stroh, Eric J. on 11/17/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var speedChecker = SpeedChecker()
    
    var body: some View {
        ScrollView{
            VStack {
                Text("Network Speed\n \(speedChecker.speed) mb/s")
                    .padding()
                    .font(.caption)
                Text("Connection Status\n \(NetworkStatus.shared.isOn ? "Connected" : "No Connection")")
                    .padding()
                    .foregroundColor(NetworkStatus.shared.isOn ? .green : .red)
                    .font(.caption)
                Text("Network Type\n \(NetworkStatus.shared.connType.description())")
                    .padding()
                    .font(.caption)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  SDSample
//
//  Created by Stroh, Eric J. on 11/17/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var speedChecker = SpeedChecker()
    
    var body: some View {
        VStack {
            Text("Network Speed\n \(speedChecker.speed) mb/s")
                .padding()
            Text("Connection Status\n \(NetworkStatus.shared.isOn ? "Connected" : "No Connection")")
                .padding()
                .foregroundColor(NetworkStatus.shared.isOn ? .green : .red)
            Text("Network Type\n \(NetworkStatus.shared.connType.description())")
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

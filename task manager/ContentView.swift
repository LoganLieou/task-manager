//
//  ContentView.swift
//  task manager
//
//  Created by Logan  Jackson on 9/18/23.
//

import SwiftUI

func listRunningTasks() -> [String] {
    let process = Process()
    var result: [String] = []
    process.launchPath = "/bin/ps"
    process.arguments = ["-A", "-o", "pid,comm"]
    
    let outputPipe = Pipe()
    process.standardOutput = outputPipe
    
    process.launch()
    
    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    if let outputString = String(data: outputData, encoding: .utf8) {
        result = outputString.components(separatedBy: "\n")
    }
    
    process.waitUntilExit()
    return result
}

struct ContentView: View {
    @State private var tasks = listRunningTasks()
    var body: some View {
        ScrollView (.vertical) {
            VStack (alignment: .leading) {
                ForEach(tasks, id: \.self) { task in
                    if (!task.contains("PID")) {
                        HStack {
                            Button(action: {
                                print("hit!")
                            }) {
                                Text("❌")
                            }
                            Text(task)
                        }
                    }
                }
            }
            .padding()
        }
        .frame(height: 500)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

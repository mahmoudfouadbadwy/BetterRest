//
//  ContentView.swift
//  BetterRest
//
//  Created by Mahmoud Fouad on 6/9/21.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    private static var defaultWakeTime: Date {
        var component  = DateComponents()
        component.hour = 7
        component.minute = 0
        return Calendar.current.date(from: component) ?? Date()
    }
    
    //MARK: - UI
    var body: some View {
        
        NavigationStack {
            
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    HeadTitle(text: "When do you want to wake up ?")
                    DatePicker("please enter a time ", selection: $wakeUp,
                               displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                }
                VStack(alignment: .leading, spacing: 0) {
                    HeadTitle(text: "Desired amount of sleep")
                    Stepper("\(sleepAmount.formatted()) hours",
                            value: $sleepAmount,
                            in: 4...12,
                            step: 0.25)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    HeadTitle(text: "Daily coffee intake")
                    Stepper(coffeAmount == 1 ? "1 cup" : "\(coffeAmount) cup(s)",
                            value: $coffeAmount,
                            in: 1...20)
                }
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("Ok")))
            }
        }
    }
    
    //MARK: - Logic
    private func calculateBedTime() {
        guard let model = try? SleepCalculator(configuration: .init()) else { return }
        let wakeUpTime = getTimeInSeconds(wakeUp)
        do {
            let prediction = try model.prediction(wake: wakeUpTime,
                                                  estimatedSleep: sleepAmount,
                                                  coffee: Double(coffeAmount))
            let sleepTime = getSleepTime(prediction.actualSleep)
            configureAlert(with: "Your ideal bedtime is…",
                           message:  sleepTime)
        } catch  {
            configureAlert(with: "Error",
                           message: "Sorry, there was a problem calculating your bedtime.")
        }
    }
    
    private func configureAlert(with title: String, message: String) {
        alertMessage = message
        alertTitle = title
        showingAlert.toggle()
    }
    
    private func getTimeInSeconds(_ date: Date) -> Double {
        let component = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (component.hour ?? 0) * 60 * 60
        let minute = (component.minute ?? 0 ) * 60
        return Double(hour + minute)
    }
    
    private func getSleepTime(_ actualSleep: Double) -> String {
        let sleepTime = wakeUp - actualSleep
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: sleepTime)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

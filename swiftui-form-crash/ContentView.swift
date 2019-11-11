//
//  ContentView.swift
//  swiftui-form-crash
//
//  Created by Majid Jabrayilov on 11/11/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import SwiftUI

extension DateFormatter {
    static var medium: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

final class SleepStore: ObservableObject {
    @Published private(set) var sleep: Sleep = .mock
    @Published var editable: Sleep = .mock

    func save() {
        sleep = editable
    }
}

struct ContentView: View {
    @EnvironmentObject var store: SleepStore
    @State private var editShown = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("inBed")) {
                    HStack {
                        Text("start")
                        Spacer()
                        Text(DateFormatter.medium.string(from: self.store.sleep.inBedInterval.start))
                    }

                    HStack {
                        Text("end")
                        Spacer()
                        Text(DateFormatter.medium.string(from: self.store.sleep.inBedInterval.end))
                    }
                }

                ForEach(self.store.sleep.asleepIntervals.indexed(), id: \.1.self) { index, _ in
                    Section(header: Text("asleep")) {
                        HStack {
                            Text("start")
                            Spacer()
                            Text(DateFormatter.medium.string(from: self.store.sleep.asleepIntervals[index].start))
                        }

                        HStack {
                            Text("end")
                            Spacer()
                            Text(DateFormatter.medium.string(from: self.store.sleep.asleepIntervals[index].end))
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .sheet(isPresented: $editShown) {
                SleepEditView().environmentObject(self.store)
            }
            .navigationBarTitle(Text(DateFormatter.medium.string(from: self.store.sleep.inBedInterval.end)))
            .navigationBarItems(trailing: Button("edit") { self.editShown = true })
        }
    }
}

struct SleepEditView: View {
    @EnvironmentObject var store: SleepStore
    @Environment(\.presentationMode) var presentation

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("inBed")) {
                    DatePicker(selection: self.$store.editable.inBedInterval.start) {
                        Text("start")
                    }

                    DatePicker(
                        selection: self.$store.editable.inBedInterval.end,
                        in: self.store.editable.inBedInterval.start...
                    ) {
                        Text("end")
                    }
                }

                ForEach(self.store.editable.asleepIntervals.indexed(), id: \.1.self) { index, _ in
                    Section(header: Text("asleep")) {
                        DatePicker(selection: self.$store.editable.asleepIntervals[index].start) {
                            Text("start")
                        }

                        DatePicker(
                            selection: self.$store.editable.asleepIntervals[index].end,
                            in: self.store.editable.asleepIntervals[index].start...
                        ) {
                            Text("end")
                        }

                        Button("delete") {
                            self.store.editable.asleepIntervals.remove(at: index)
                        }
                    }
                }

                Section {
                    Button("addAsleepInterval") {
                        self.store.editable.asleepIntervals.append(
                            self.store.editable.inBedInterval
                        )
                    }

                    Button("save") {
                        self.presentation.wrappedValue.dismiss()
                        self.store.save()
                    }.disabled(store.editable.asleepIntervals.isEmpty)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

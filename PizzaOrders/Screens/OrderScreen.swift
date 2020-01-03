//
//  OrderScreen.swift
//  PizzaOrders
//
//  Created by Jay Phillips on 1/3/20.
//  Copyright © 2020 Jay Phillips. All rights reserved.
//

import SwiftUI

struct OrderScreen: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment (\.presentationMode) var presentationMode
    
    let types = ["Pepporoni", "Sausage", "Cheese", "Supreame", "Meat Lovers", "Hawaiian", "Chicago Deep Dish", "New York Thin"]
    
    @State var selectedPizzaIndex = 0
    @State var numberOfSlices = 0
    @State var tableNumber = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Pizza Details")) {
                    Picker(selection: $selectedPizzaIndex, label: Text("Type of Pizza")) {
                        ForEach(0 ..< types.count) {
                            Text(self.types[$0]).tag($0)
                        }
                    }
                    
                    Stepper("\(numberOfSlices) Slices", value: $numberOfSlices, in: 1...12)
                }
                
                Section(header: Text("Table")) {
                    TextField("Table Number", text: $tableNumber)
                        .keyboardType(.numberPad)
                }
                
                Button(action: {
                    guard self.tableNumber != "" else {return}
                    let newOrder = Order(context: self.managedObjectContext)
                    newOrder.type = self.types[self.selectedPizzaIndex]
                    newOrder.orderStatus = .pending
                    newOrder.tableNumber = self.tableNumber
                    newOrder.numberOfSlices = Int16(self.numberOfSlices)
                    newOrder.id = UUID()
                    do {
                        try self.managedObjectContext.save()
                        print("Order saved.")
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                }) {
                    Text("Add Order")
                }
            .navigationBarTitle("Add Order")
            }
        }
    }
}

struct OrderScreen_Previews: PreviewProvider {
    static var previews: some View {
        OrderScreen()
    }
}

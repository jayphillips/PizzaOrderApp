//
//  ContentView.swift
//  PizzaOrders
//
//  Created by Jay Phillips on 1/3/20.
//  Copyright © 2020 Jay Phillips. All rights reserved.
//

import SwiftUI
import CoreData


struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Order.entity(), sortDescriptors: [])
    //,
//                  predicate: NSPredicate(format: "status != %@", Status.completed.rawValue))
    
    var orders: FetchedResults<Order>
    
    @State var showOrderScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(orders) {
                    order in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(order.type) - \(order.numberOfSlices) slices")
                                .font(.headline)
                            Text("Table \(order.tableNumber)")
                                .font(.subheadline)
                        }
                        Spacer()
                        Button(action: {
                            self.updateOrder(order: order)
                        }) {
                            Text(order.orderStatus == .pending ? "Prepare" : "Complete")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .onDelete { indexSet in for index in indexSet {
                    self.managedObjectContext.delete(self.orders[index])
                    }}
            }
        .navigationBarTitle("My Orders")
            .navigationBarItems(trailing: Button(action: {
                self.showOrderScreen = true
            }, label: {
                Image(systemName: "plus.circle")
                .resizable()
                    .frame(width: 32, height: 32, alignment: .center)
                    .sheet(isPresented: $showOrderScreen) {
                        OrderScreen().environment(\.managedObjectContext, self.managedObjectContext)
                }
            }))
        }
    }
    func updateOrder(order: Order) {
        let newStatus = order.orderStatus
            //== .pending ? Status.preparing : .completed
        self.managedObjectContext.performAndWait {
            order.orderStatus = newStatus
            try? managedObjectContext.save()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

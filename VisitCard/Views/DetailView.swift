//
//  DetailView.swift
//  VisitCard
//
//  Created by Damien DELES on 18/03/2021.
//

import SwiftUI
import MapKit

struct DetailView: View {
    // MARK: - States
    @State private var showingEditView = false
    
    // MARK: - Variables
    @ObservedObject var card: Card
    
    // MARK: - Environment
    @Environment(\.managedObjectContext) private var moc
    
    // MARK: - Functions
    var body: some View {
        ZStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Image(uiImage: ImageManager.loadUIImage(fileName: card.fileName))
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200, alignment: .center)
                        Spacer()
                    }
                }
                
                Section(header: Text("Main information")) {
                    HStack {
                        Text("Firstname:")
                        Text(card.firstName)
                            .fontWeight(.bold)
                    }
                    HStack {
                        Text("Lastname:")
                        Text(card.lastName)
                            .fontWeight(.bold)
                    }
                }
                
                Section(header: Text("Others")) {
                    HStack {
                        Text("Society:")
                        Text(card.society)
                            .fontWeight(.bold)
                    }
                }
                
                Section(header: Text("Localisation")) {
                    MapView(coordinate: .constant(CLLocationCoordinate2D(latitude: card.latitude, longitude: card.longitude)))
                        .frame(height:400)
                        .disabled(true)
                }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 44, trailing: 0))
            
            VStack {
                Spacer()
                Button(action: {
                    showingEditView = true
                }, label: {
                    Text("Edit")
                        .hwButtonStyle()
                })
            }
        }
        .navigationBarTitle("\(card.firstName) \(card.lastName)", displayMode: .inline)
        .sheet(isPresented: $showingEditView, content: {
            EditView(cardId: card.id)
                .environment(\.managedObjectContext, moc)
                .environmentObject(card)
        })
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let card = Card(context: moc)
        card.id = UUID()
        card.firstName = "Damien"
        card.lastName = "Délès"
        card.society = "Porteo"
        card.fileName = "Image path"
        card.latitude = 10.5
        card.longitude = 43.1
        return DetailView(card: card)
    }
}

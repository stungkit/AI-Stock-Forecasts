import SwiftUI

struct CompanyView: View {
    
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) var presentation
    
    var company: CustomCompany
    
    @State private var showingAlert: Bool = false
    @State private var modificationMode: Bool = false
    @State private var newName: String = ""
    @State private var newId: String = ""
    @State private var newArobase: String = ""
    @State private var newSector: Sector = Sector.all
    
    func updateFields() {
        newName = company.wrappedName
        newId = company.wrappedId
        newArobase = company.wrappedArobase
        //newSector = company.wrappedSector
    }
    
    var body: some View {
        Form {
            Image("custom")
                .resizable()
                .scaledToFit()
            // Text in display mode or Texfield in modification mode
            Section(header: Text("Name")) {
                modificationMode ? AnyView(TextField(company.wrappedName, text: $newName)) : AnyView(Text(company.wrappedName))
            }
            // Text in display mode or Texfield in modification mode
            Section(header: Text("Stock Symbol")) {
                modificationMode ? AnyView(TextField(company.wrappedId, text: $newId)) : AnyView(Text(company.wrappedId))
            }
            // Text in display mode or Texfield in modification mode
            Section(header: Text("Twitter @")) {
                modificationMode ? AnyView(TextField(company.wrappedArobase, text: $newArobase)) : AnyView(Text(company.wrappedArobase))
            }
            // Text in display mode or Picker in modification mode
            Section(header: Text("Sector")) {
                modificationMode ?
                    AnyView(Picker(selection: $newSector, label: Text("")) {
                        ForEach(Sector.allCases, id:\.self) { sector in
                            Text(sector.rawValue.capitalized).tag(sector.rawValue)
                        }
                    }) :
                    AnyView(Text(company.wrappedSector.capitalized))
            }
            Section(header: Text("Modify or Delete")) {
                // Modify Button in display mode or Cancel Button in modification mode
                modificationMode ?
                    Button("Cancel") {
                        modificationMode = false
                    } :
                    Button("Modify") {
                        modificationMode = true
                    }
                // Delete Button in display mode or Save Button in modification mode
                modificationMode ?
                    Button("Save") {
                        company.arobase = newArobase
                        company.id = newId
                        company.name = newName
                        company.sector = newSector.rawValue
                        if moc.hasChanges {
                            do {
                                try moc.save()
                            } catch {
                                print("Cannot save ---> \(error.localizedDescription)")
                            }
                        }
                        modificationMode = false
                    }.foregroundColor(.green) :
                    Button("Delete") {
                        showingAlert = true
                    }.foregroundColor(.red)
            }
        }
        .navigationTitle(company.wrappedName)
        .onAppear(perform: updateFields)
        .alert(isPresented: $showingAlert) { () -> Alert in
            Alert(
                title: Text("Delete Company"),
                message: Text("The deletion is permanent and cannot be undone. Are you sure?"),
                primaryButton: .cancel(Text("Cancel")),
                secondaryButton: .destructive(Text("Delete"), action: {
                    moc.delete(company)
                    if moc.hasChanges {
                        do {
                            try moc.save()
                        } catch {
                            print("Cannot delete ---> \(error.localizedDescription)")
                        }
                    }
                    presentation.wrappedValue.dismiss()
                }))
        }
    }
}

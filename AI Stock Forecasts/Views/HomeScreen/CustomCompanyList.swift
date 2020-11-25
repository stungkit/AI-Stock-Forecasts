import SwiftUI

struct CustomCompanyList: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: CustomCompany.entity(), sortDescriptors: []) var customCompanies: FetchedResults<CustomCompany>
    
    var body: some View {
        List(customCompanies) { company in
            NavigationLink(destination: CompanyView(company: company)) {
                HStack {
                    Text(company.wrappedName)
                    Spacer()
                    Text(company.wrappedId)
                }
            }
        }
        .navigationTitle("Your custom companies")
        .navigationBarTitleDisplayMode(.inline)
    }
}

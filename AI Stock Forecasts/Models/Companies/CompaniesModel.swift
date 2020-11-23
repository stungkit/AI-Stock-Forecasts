import Foundation

struct CompaniesModel {
    
    static func readPropertyList() -> [[String:String]]? {
        guard let path = Bundle.main.path(forResource: "companies", ofType: "plist") else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [[String:String]] else {
            return nil
        }
        return plist
    }
    
    static func getAllCompaniesFromSector(for sector: String) -> [Company]? {
        if let fullPlist = readPropertyList() {
            var companyList: [Company] = []
            for company in fullPlist {
                if company["sector"] == sector || sector == "all" {
                    companyList.append(
                        Company(name: company["name"] ?? "ERROR",
                                hash: company["hash"] ?? "ERROR",
                                arobase: company["arobase"] ?? "ERROR"
                        )
                    )
                }
            }
            return companyList
        }
        print("getSector failed")
        return nil
    }
}

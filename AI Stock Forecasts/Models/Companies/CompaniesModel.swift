//
//  CompaniesModel.swift
//  Stock Forecasts
//
//  Created by Alexis on 9/19/20.
//

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
    
    static var names: [String]? {
        if let fullPlist = readPropertyList() {
            var companyNames = [String]()
            for company in fullPlist {
                companyNames.append(company["name"]!)
            }
            return companyNames
        }
        print("KO :(")
        return nil
    }
    
    static func getNames(for sector: String) -> [String]? {
        if let fullPlist = readPropertyList() {
            var companyNames = [String]()
            for company in fullPlist {
                if company["sector"] == sector {
                    companyNames.append(company["name"]!)
                }
            }
            return companyNames
        }
        print("KO :(")
        return nil
    }
    
    static var hashes: [String]? {
        if let fullPlist = readPropertyList() {
            var companyHashes = [String]()
            for company in fullPlist {
                companyHashes.append(company["hash"]!)
            }
            return companyHashes
        }
        print("KO :(")
        return nil
    }
    
    static func getHashes(for sector: String) -> [String]? {
        if let fullPlist = readPropertyList() {
            var companyNames = [String]()
            for company in fullPlist {
                if company["sector"] == sector {
                    companyNames.append(company["hash"]!)
                }
            }
            return companyNames
        }
        print("KO :(")
        return nil
    }
    
    static var arobases: [String]? {
        if let fullPlist = readPropertyList() {
            var companyArobazes = [String]()
            for company in fullPlist {
                companyArobazes.append(company["arobase"]!)
            }
            return companyArobazes
        }
        print("KO :(")
        return nil
    }
    
    static func getArobases(for sector: String) -> [String]? {
        if let fullPlist = readPropertyList() {
            var companyNames = [String]()
            for company in fullPlist {
                if company["sector"] == sector {
                    companyNames.append(company["arobase"]!)
                }
            }
            return companyNames
        }
        print("KO :(")
        return nil
    }
    
    static func getSector(for sector: String) -> [Company]? {
        if let fullPlist = readPropertyList() {
            var companyList = [Company]()
            for company in fullPlist {
                if company["sector"] == sector {
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

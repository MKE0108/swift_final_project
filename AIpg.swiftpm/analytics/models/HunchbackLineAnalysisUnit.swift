import SwiftUI

let InDateFormat = "MM/dd"
let RealtimeFormat = "MM/dd/HH:mm:ss"

struct HunchbackLineAnalysisUnit : Identifiable {
    let id = UUID()
    var currentTime: String
    var count: Int
    
    static var dateExamples = [
        HunchbackLineAnalysisUnit(currentTime: "12/10", count: 10),
        HunchbackLineAnalysisUnit(currentTime: "12/11", count: 1),
        HunchbackLineAnalysisUnit(currentTime: "12/12", count: 5),
        HunchbackLineAnalysisUnit(currentTime: "12/12", count: 6),
        HunchbackLineAnalysisUnit(currentTime: "12/24", count: 15),
        HunchbackLineAnalysisUnit(currentTime: "12/25", count: 50),
        HunchbackLineAnalysisUnit(currentTime: "12/26", count: 100),
        HunchbackLineAnalysisUnit(currentTime: "12/27", count: 90),
        HunchbackLineAnalysisUnit(currentTime: "12/28", count: 30),
        HunchbackLineAnalysisUnit(currentTime: "12/29", count: 20),
        HunchbackLineAnalysisUnit(currentTime: "12/31", count: 10),
        HunchbackLineAnalysisUnit(currentTime: "01/01", count: 90),
        HunchbackLineAnalysisUnit(currentTime: "01/28", count: 30),
        HunchbackLineAnalysisUnit(currentTime: "01/29", count: 20),
        HunchbackLineAnalysisUnit(currentTime: "01/31", count: 10)
    ]
}

func hunchbackLineAnalysisUnitToRaw(hunchbackLineAnalysisUnits: inout [HunchbackLineAnalysisUnit]) -> ([String], [Int]) {
    var currentTimes = [String]()
    var counts = [Int]()
    
    for unit in hunchbackLineAnalysisUnits {
        currentTimes.append(unit.currentTime)
        counts.append(unit.count)
    }
    
    return (currentTimes, counts)
}

func lineAnalysisRawsToHunchbackUnits(currentTimes: inout [String], counts: inout [Int]) -> [HunchbackLineAnalysisUnit] {
    var units = [HunchbackLineAnalysisUnit]() 
    
    for (index, _) in currentTimes.enumerated() {
        units.append(HunchbackLineAnalysisUnit(currentTime: currentTimes[index], count: counts[index]))
    }
    
    return units
}

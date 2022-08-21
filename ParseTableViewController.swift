//
//  ParseTableViewController.swift
//  MyWater
//
//  Created by Panashe Muzangaza on 20/8/2022.
//

import UIKit
import CSV


class ParseTableViewController: UITableViewController {
    
    static var allRecordings = [WaterRecording]()
    private var day30Recordings: [WaterRecording] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.showLoading()
        DispatchQueue.global().async {
            ParseTableViewController.allRecordings = self.getAllRecords()
            self.day30Recordings = self.getRecordsForManaagedObject(id: 81968801)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.title = self.day30Recordings.last?.GetShortDate()
                self.navigationItem.stopLoading()
            }
        }
    }
    
    
    private func getRecordsForManaagedObject(id: Int) -> [WaterRecording] {
        return ParseTableViewController.allRecordings.filter({$0.ManagedObjectid == id})
    }
    
    private func getAllRecords() -> [WaterRecording]
    {
        guard let url = getCsvFileUrl() else{
            return []
        }
        
        guard let data = FileManager.default.contents(atPath: url.path) else{
            return []
        }
        
        let parser = CSVParser(data: data, hasHeader: true, header: ["time", "ManagedObjectid", "typeM", "Series", "Unit", "Value"])
        var all = parser.loadAll()
        all?.removeFirst()
        
        let records = all?.map({ (r: [String]) in
            WaterRecording(r[0],
                           Int(r[1])!,
                           r[2],
                           r[3],
                           r[4],
                           (r.count < 6) ? 0 : (Int(r[5]) ?? 0))
        })
        
        return records ?? []
    }
    
    private func getCsvFileUrl()->URL?
    {
        if let urlString = Bundle.main.path(forResource: "DigitalMeterDataJun30", ofType: "csv"){
            return URL(string: urlString);
        }
        
        return nil
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 40
        }else if indexPath.row == 1{
            return 200
        }
        else {
            return 200
        }
    }
    
    private let removableTag = 94827
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellPadding : CGFloat = 20.0
        let paddingFactor = CGFloat(1.00)
        
        var cell = UITableViewCell()
        
        
        if indexPath.row == 1 {
            let title = UILabel(frame: CGRect(x: 0, y: (cellPadding * paddingFactor), width: cell.contentView.frame.size.width, height: 20.0))
            title.font = .boldSystemFont(ofSize: 14)
            title.textColor = .systemTeal
            title.autoresizingMask = [.flexibleWidth]
            title.textAlignment = .center
            title.text = "Today Morning usage:"
            title.tag = removableTag
            cell.contentView.addSubview(title)
        
            let barGraph = getDayLineChart()
            barGraph.frame = CGRect(
                x: cellPadding * paddingFactor,
                y: title.frame.origin.y + title.frame.size.height + cellPadding,
                width: cell.contentView.frame.size.width - (cellPadding * (paddingFactor * 2)),
                height: cell.contentView.frame.size.height - (title.frame.origin.y + title.frame.size.height + cellPadding) - (cellPadding * (paddingFactor * 2)))
            barGraph.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            barGraph.tag = removableTag
            cell.contentView.addSubview(barGraph)
            cell.accessoryType = .none
        }
        else if indexPath.row == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "blue") ?? UITableViewCell()
        }
        
        return cell
    }
    
    
    private var _dayHoursLineChartDataSource : DayHoursDataSource!
    private func getDayLineChart() -> PVMLineGraphChartView
    {
        //chart
        let dayHoursLineChart = PVMLineGraphChartView()
        dayHoursLineChart.noDataText = "Loading..."
        //datasource
        _dayHoursLineChartDataSource = DayHoursDataSource(recordings: day30Recordings)
        dayHoursLineChart.dataSource = _dayHoursLineChartDataSource
        return dayHoursLineChart
    }
}

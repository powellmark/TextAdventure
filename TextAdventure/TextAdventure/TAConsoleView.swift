//
//  TAConsoleView.swift
//  TextAdventure
//
//  Created by Mark Powell on 3/22/18.
//  Copyright © 2018 Mark Powell. All rights reserved.
//

import UIKit

class TAConsoleTableViewCell: UITableViewCell {
    @IBOutlet var consoleLabel: UILabel!
    
}

class TAConsoleDataHandler: NSObject {
    private var consoleData: [String]
    var maxBufferSize: Int = 100
    
    override init() {
        consoleData = [String]()
    }
    
    func addConsoleOutput(_ output: String) {
        consoleData.append(output)
        
        if consoleData.count > maxBufferSize {
            consoleData.remove(at: 0)
        }
    }
}

extension TAConsoleDataHandler: UITableViewDelegate {
}

extension TAConsoleDataHandler: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consoleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "consoleTableViewCellId") as? TAConsoleTableViewCell {
            
            cell.consoleLabel.text = consoleData[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
}

class TAConsoleView: UITableView {
    let dataHandler: TAConsoleDataHandler = TAConsoleDataHandler()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        customInit()
    }
    
    private func customInit() {
        self.dataSource = dataHandler
        self.delegate = dataHandler
    }
    
    func appendToConsole(_ output: String) {
        dataHandler.addConsoleOutput(output)
        reloadData()
        scrollToLastRow(false)
    }
    
    func scrollToLastRow(_ animated: Bool) {
        
        let lastSection = numberOfSections - 1
        let lastRow = numberOfRows(inSection: lastSection) - 1
        
        if lastRow >= 0, lastSection >= 0 {
            let lastIndexPath = IndexPath(row: lastRow, section: lastSection)
            scrollToRow(at: lastIndexPath, at: .bottom, animated: animated)
        }
    }
}

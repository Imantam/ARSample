//
//  ARListViewController.swift
//  ARSampleApplication
//
//  Created by Yuya Imagawa on 2018/01/17.
//  Copyright © 2018年 Tobila Systems. All rights reserved.
//

import UIKit

// MARK: - struct

struct Sample {
    let title: String
    let detail: String
    let classPrefix: String
    
    func controller() -> UIViewController {
        let storyboard = UIStoryboard(name: classPrefix, bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() else {fatalError()}
        controller.title = title
        return controller
    }
}

struct SampleDataSource {
    let samples = [
        Sample(
            title: "オブジェクト配置",
            detail: "検出した平面にオブジェクトを配置します",
            classPrefix: "ARPutObject"
        ),
        Sample(
            title: "メジャー",
            detail: "２点間の距離を測ります",
            classPrefix: "ARMeasure"
        ),
        Sample(
            title: "空中描画",
            detail: "線を空間に描画します",
            classPrefix: "ARDrawing"
        ),
        ]
}

// MARK: - class

class ARListCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showSample(_ sample: Sample) {
        titleLabel.text  = sample.title
        detailLabel.text = sample.detail
    }
}

class ARListViewController: UITableViewController {
    
    private let dataSource = SampleDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.samples.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ARListCell else {fatalError()}
        
        let sample = dataSource.samples[(indexPath as NSIndexPath).row]
        cell.showSample(sample)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sample = dataSource.samples[(indexPath as NSIndexPath).row]
        
        navigationController?.pushViewController(sample.controller(), animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



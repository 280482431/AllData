//
//  FirstViewController.swift
//  AllData
//
//  Created by lvfeijun on 2018/7/16.
//  Copyright © 2018年 lvfeijun. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

//    var chartView: PieChartView!

    var ctl:lvfjStockViewController = lvfjStockViewController.init(name: "腾讯", code:"00700")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ctl.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300);
        self.view .addSubview(ctl.view);
        ctl.fetchData("00700");
//        self.addChildViewController(ctl);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


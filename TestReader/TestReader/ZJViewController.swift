//
//  ZJViewController.swift
//  TestReader
//
//  Created by 刘战军 on 16/11/29.
//  Copyright © 2016年 LiuZhanJun. All rights reserved.
//

import UIKit

class ZJViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let download = ZJDownLoad()
        download.view.frame = self.view.bounds
        download.url = "http://......" // 这里可以放epub文件下载地址url
        view.addSubview(download.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

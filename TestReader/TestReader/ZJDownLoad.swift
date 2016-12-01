//
//  ZJViewController.swift
//  TestReader
//
//  Created by 刘战军 on 16/11/29.
//  Copyright © 2016年 LiuZhanJun. All rights reserved.
//

import UIKit
import Alamofire

class ZJDownLoad: UIViewController {
    
    var url             : String! /** 必填参数, 传入url */
    
    private var dataPath: String? // 获取下载路径
    
    var progressView    : ZJProgress = { /** 这个方法可以自定义 */
        let progressView = ZJProgress(frame: CGRectMake(100, 300, 200, 200))
        progressView.titleLabel?.text = "downLoad"
        return progressView
    }()
    
    var button          : UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 40, width: 200, height: 50))
        button.backgroundColor = UIColor.redColor()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.addTarget(self, action: #selector(didClickButton(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(button)
        
        view.addSubview(progressView)
        
        dataPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func didClickButton(button: UIButton) {
        statusDownLoad()
    }
    
    private func statusDownLoad() {
        
        let urlPath = NSURL(string: url)
        let str = urlPath?.lastPathComponent
        if str == "" {
            return
        }
        let indexStr = str?.endIndex.advancedBy(-5)
        let urlStr2 = str?.substringToIndex(indexStr!)
        
        /** 文件内存大小, 以字符串的方式返回 */
        let files = NSFileManager.defaultManager().subpathsAtPath(dataPath!)
        
        var flag = 1
        /** 取出所有文件名 */
        for fileName in files! {
            
            if fileName == "\(urlStr2 ?? "").epub" {
                flag = 2
                setDownLoadFile()
            }
        }
        
        if flag != 2 {
            
            /** 这里进行数据的下载 */
            downLoadFile(url)
        }
    }
    
    private func setDownLoadFile() {
        
        let urlPath = NSURL(string: "\(self.url ?? "")")
        let str = urlPath?.lastPathComponent
        if str == "" {
            print("图书有问题")
            return
        }
        let indexStr = str?.endIndex.advancedBy(-5)
        let urlStr2 = str?.substringToIndex(indexStr!)
        
        // 1、获得沙盒的根路径
        let home = NSHomeDirectory() as NSString
        // 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        // 3、获取文本文件路径
        let filePath = docPath.stringByAppendingPathComponent("\(urlStr2 ?? "").epub");
        
        /** 把文件名拼接到路径中 */
        let url = NSURL(string: filePath)
        
        let pageView = LSYReadPageViewController()
        pageView.resourceURL = url
        
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            var timeout :NSTimeInterval = 0; // 添加下载超时, 因为下载的图书在本地生成需要时间
            while(!NSFileManager.defaultManager().fileExistsAtPath(url!.absoluteString)){
                sleep(1);
                timeout+=1;
                if (timeout > 3){
                    break;
                }
            }
            if (!NSFileManager.defaultManager().fileExistsAtPath(url!.absoluteString)){
                print("文件不存在")
                return;
            }
            pageView.model = LSYReadModel.getLocalModelWithURL(url) as? LSYReadModel
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(pageView, animated: true, completion: nil)
            })
        }
    }
    
    /// 文件下载，获取文件下载进度
    private func downLoadFile(fileURL: String) {
        //下载文件的保存路径
        let destination = Alamofire.Request.suggestedDownloadDestination(
            directory: .DocumentDirectory, domain: .UserDomainMask)
        var downloadRequest: Request!
        // 页面加载完毕就自动开始下载
        downloadRequest = Alamofire.download(.GET, url, destination: destination)
        // 下载进度
        downloadRequest.progress(downloadProgress)
        // 下载停止
        downloadRequest.response(completionHandler: downloadResponse)
        
    }
    
    // 下载过程中改变进度条
    func downloadProgress(bytesRead: Int64, totalBytesRead: Int64, totalBytesExpectedToRead: Int64) {
        let percent = Float(totalBytesRead)/Float(totalBytesExpectedToRead)
        // 进度条更新
        dispatch_async(dispatch_get_main_queue()) {
            self.progressView.process = percent
        }
        print("当前进度: \(percent*100)%")
        
        if percent == 1.0 { // 当进度为1的时候进行图书阅读
            self.setDownLoadFile()
        }
    }
    
    //下载停止响应（不管成功或者失败）
    private func downloadResponse(request: NSURLRequest?, response: NSHTTPURLResponse?,
                          data: NSData?, error:NSError?) {
        if let error = error {
            if error.code == NSURLErrorCancelled {
                //意外终止的话，进行其他操作
                dispatch_async(dispatch_get_main_queue()) {
                    
                    let alertVc = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
                    let alertActionCancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                    let alertActionDone = UIAlertAction(title: "确定", style: .Default, handler: { (UIAlertAction) in
                        
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        
                    })
                    alertVc.addAction(alertActionCancel)
                    alertVc.addAction(alertActionDone)
                    self.navigationController?.presentViewController(alertVc, animated: true, completion: nil)
                }
            } else {
                print("Failed to download file: \(response) \(error)")
            }
        } else {
            print("Successfully downloaded file: \(response)")
        }
    }
}

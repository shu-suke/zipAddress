//
//  ViewController.swift
//  zipAddress
//
//  Created by kin_shusuke on 2015/12/13.
//  Copyright © 2015年 shusuke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var zipTextField: UITextField!
    @IBAction func tapReturn() {
    }

    @IBAction func tapSearch() {
        guard let ziptext = zipTextField.text else {
            // 値がnilだったら終了
            return
        }
//        リクエストするURLを作成
        let urlStr = "http://api.zipaddress.net/?zipcode=\(ziptext)"
        
        if let url = NSURL(string: urlStr) {
//            urlオブジェクトがnilでなかったら、検索処理オブジェクトを作る
            let urlSession = NSURLSession.sharedSession()
//            「検索処理が完了したらonGetAddressを呼び出す」というタスクを作る
            let task = urlSession.dataTaskWithURL(url, completionHandler: self.onGetAddress)
//            タスクを実行する
            task.resume()
        }

    }
//    検索処理が完了したら実行する
    func onGetAddress(data: NSData?,res: NSURLResponse?, error: NSError?){
        
//        受け取ったデータをJSON解析する。もしエラーならcatchへジャンプする
        do{
//            dataをJSON解析を実行する
            let jsonDic = try NSJSONSerialization.JSONObjectWithData(
                data!, options: NSJSONReadingOptions.MutableContainers ) as! NSDictionary
//            解析した値を調べていく
            if let code = jsonDic["code"] as? Int {
//                codeという項目が整数なら、住所検索APIからのコード情報
                if code != 200 {
//                    codeが200でないときは、検索エラー
                    if let errmsg = jsonDic["message"] as? String {
//                        エラーメッセージを表示
                        print(errmsg)
                    }
                }
            }
            if let data = jsonDic["data"] as? NSDictionary {
//                dataという項目が辞書データなら、その中身を調べる
                if let pref = data["pref"] as? String {
//                    data内のprefという項目が文字列なら、県名
                    print("県名は\(pref)です")
                }
                if let address = data["address"] as? String {
//                    data内のaddressという項目が文字列なら、住所
                    print("住所は\(address)です")
                }
            }
        } catch {
//            json解析に失敗した時に実行
            print("エラーです")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


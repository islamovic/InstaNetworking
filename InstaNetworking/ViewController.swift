//
//  ViewController.swift
//  InstaNetworking
//
//  Created by Islam on 2/6/20.
//  Copyright © 2020 App Lineup. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        testGetRequest()
        testPostRequest()
    }
}

extension ViewController {

    func testGetRequest() {
        let path = "posts/"
        let endPoint = InstaEndPoint(path: path, method: .get)
        InstaRouter.shared.request(endPoint, success: { (data, response) in
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                print(json)
            } catch (let error) {
                print(error.localizedDescription)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    func testPostRequest() {

        let path = "posts"
        let params = ["title": "Hamada", "body": "Hamada bar", "userId": 200] as [String : Any]
        let postEndPoint = InstaEndPoint(path: path, parameters: params, method: .post)

        InstaRouter.shared.request(postEndPoint, success: { (data, response) in
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                print(jsonObject)
            } catch (let error) {
                print(error.localizedDescription)
            }
        }) { (error) in
            print(error.localizedDescription)
        }

    }
}

//
//  Store.swift
//  StoreApp
//
//  Created by oingbong on 11/12/2018.
//  Copyright © 2018 oingbong. All rights reserved.
//

import Foundation

class Store {
    private var storeItemGroup = [StoreItemGroup]() {
        didSet {
            NotificationCenter.default.post(name: NotificationKey.updateItem, object: nil)
        }
    }
    
    var storeItemGroupCount: Int {
        return storeItemGroup.count
    }
    
    func appendItem(with isReachable: Bool) {
        isReachable ? connectedInternet() : unConnectedInternet()
    }
    
    private func connectedInternet() {
        for item in Topic.allCases {
            parseUrl(topic: item) { (storeItemGroup) in
                self.imageUrl(at: item.rawValue, with: storeItemGroup)
            }
        }
    }
    
    private func unConnectedInternet() {
        for item in Topic.allCases {
            parse(topic: item)
        }
    }
    
    // MARK: for file
    private func parse(topic: Topic) {
        guard let jsonData = LocalFileManager.json(fileName: topic.englihsName), let storeItems: [StoreItem] = Parser.decode(from: jsonData) else {
            NotificationCenter.default.post(name: NotificationKey.error, object: nil)
            return
        }
        let storeItemGroup = StoreItemGroup(sectionName: topic.englihsName, sectionObjects: storeItems)
        self.storeItemGroup.append(storeItemGroup)
    }
    
    // MARK: for url
    private func parseUrl(topic: Topic, handler: @escaping (StoreItemGroup) -> Void ) {
        NetworkManager.jsonUrl(fileName: topic.englihsName) { (storeItems) in
            guard let items = storeItems, let storeItems: [StoreItem] = Parser.decode(from: items) else {
                NotificationCenter.default.post(name: NotificationKey.error, object: nil)
                return
            }
            let storeItemGroup = StoreItemGroup(sectionName: topic.englihsName, sectionObjects: storeItems)
            self.storeItemGroup.append(storeItemGroup)
            handler(storeItemGroup)
        }
    }
    
    // MARK: for image
    private func imageUrl(at sectionIndex: Int, with storeItemGroup: StoreItemGroup) {
        for index in 0..<storeItemGroup.sectionObjects.count {
            let fileName = storeItemGroup.sectionObjects[index].image.components(separatedBy: "/").last!
            let isExist = LocalFileManager.fileExists(fileName: fileName)
            if !isExist {
                guard let url = URL(string: storeItemGroup.sectionObjects[index].image) else { return }
                let indexPath = IndexPath(row: index, section: sectionIndex)
                download(url: url, indexPath: indexPath)
            }
        }
    }
    
    private func download(url: URL, indexPath: IndexPath) {
        DispatchQueue.global().async {
            NetworkManager.imageDownLoad(with: url, handler: { (_) in
                NotificationCenter.default.post(name: NotificationKey.updateItemCell, object: nil, userInfo: ["indexPath": indexPath])
            })
        }
    }
    
    // MARK: for Detail
    func detailHash(with indexPath: IndexPath) -> String {
        return storeItemGroup[indexPath.section].sectionObjects[indexPath.row].detailHash
    }
    
    func title(with indexPath: IndexPath) -> String {
        return storeItemGroup[indexPath.section].sectionObjects[indexPath.row].title
    }

    subscript(index: Int) -> StoreItemGroup {
        return storeItemGroup[index]
    }
}

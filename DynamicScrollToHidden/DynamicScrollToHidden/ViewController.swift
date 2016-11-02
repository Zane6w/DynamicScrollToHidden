//
//  ViewController.swift
//  DynamicScrollToHidden
//
//  Created by zhi zhou on 2016/11/2.
//  Copyright © 2016年 zhi zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    // MARK:- 属性
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // 初始 tableView 偏移量
    var contentOffsetY: CGFloat = 0.0
    
    // toolBar 的 Y 坐标值
    var toolBarY: CGFloat = 0.0
    
    // MARK:- 系统函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化 toolBar 的 Y 坐标值
        toolBarY = self.toolBar.frame.origin.y
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

// MARK:- tableView 代理方法
extension ViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}

// MARK:- 滚动代理方法
extension ViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // tableView 的动态偏移量 Y 值
        let dynamicContentOffsetY = self.tableView.contentOffset.y
        
        // 剔除偏移量为负值的情况
        guard self.tableView.contentOffset.y >= 0 else {
            return
        }
        
        // 根据 tableView 的 contentSize 计算有效的最大偏移量
        let contentSizeHeight = self.tableView.contentSize.height
        let MaxContentOffsetY = contentSizeHeight - UIScreen.main.bounds.size.height
        
        /* 手势向上滑动的情况
           如果：tableView “动态Y轴 偏移量”大于“初始化Y轴 偏移量”, 并且“动态Y轴 偏移量”在 contentSize 范围内, 则执行.
         
         */
        if dynamicContentOffsetY > self.contentOffsetY, dynamicContentOffsetY <= MaxContentOffsetY {
            if self.toolBar.frame.origin.y >= UIScreen.main.bounds.size.height {
                self.toolBar.frame.origin.y = UIScreen.main.bounds.size.height
            }else {
                let newOffsetY = dynamicContentOffsetY - self.contentOffsetY
                self.toolBar.frame.origin.y += newOffsetY
            }
        }
        
        /* 手势向下滑动的情况
           如果：tableView “动态Y轴 偏移量”小于“初始化Y轴 偏移量”, 则执行.
         */
        if dynamicContentOffsetY < self.contentOffsetY {
            if self.toolBar.frame.origin.y <= self.toolBarY {
                self.toolBar.frame.origin.y = self.toolBarY
            }else {
                let newOffsetY = self.contentOffsetY - dynamicContentOffsetY
                self.toolBar.frame.origin.y -= newOffsetY
            }
        }
        
        // 更新初始化的 tableView 的 Y轴 偏移量, 便于对比判断.
        self.contentOffsetY = self.tableView.contentOffset.y
        
    }
    
    // 手动结束滚动时调用
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 更新初始化的 tableView 的 Y轴 偏移量, 便于对比判断.
        self.contentOffsetY = self.tableView.contentOffset.y
    }
    
    // 滚动效果结束时调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 更新初始化的 tableView 的 Y轴 偏移量, 便于对比判断.
        self.contentOffsetY = self.tableView.contentOffset.y
    }
}



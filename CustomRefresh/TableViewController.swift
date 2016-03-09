//
//  TableViewController.swift
//  CustomRefresh
//
//  Created by xinye lei on 16/3/7.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let dataArray = [String](count: 10, repeatedValue: "DATA")
    let newDataArray = [String](count: 10, repeatedValue: "NEWDATA")

    var refreshView: UIView?
    
    var compass: UIImageView?
    var spinner: UIImageView?
    
    var horizontolDistance: CGFloat = 0
    let verticleDistance: CGFloat = 150
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        let refreshV = UIView(frame: refreshControl!.bounds)
        compass = UIImageView(frame: refreshV.bounds)
        let image = UIImage(named: "background")
        compass!.frame.size = image!.size
        compass!.image = image
        refreshV.addSubview(compass!)
        spinner = UIImageView(frame: refreshV.bounds)
        let sImage = UIImage(named: "spinner")
        spinner!.frame.size = sImage!.size
        spinner!.image = sImage
        spinner!.frame.origin.x = refreshV.bounds.size.width - spinner!.frame.size.width
        refreshV.addSubview(spinner!)
        refreshControl!.addSubview(refreshV)
        //refreshControl!.tintColor = UIColor.clearColor()
        refreshView = refreshV
        horizontolDistance = refreshView!.bounds.size.width / 2 - compass!.center.x


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func refresh() {
        let queue = dispatch_queue_create("q", nil)
        animatingRefreshing()
        dispatch_async(queue) { () -> Void in
            sleep(3)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.refreshControl!.endRefreshing()
                self.compass!.frame.origin.x = 0
                self.spinner!.frame.origin.x = self.refreshView!.bounds.width - self.spinner!.frame.width
            })
        }
    }
    
    func animatingRefreshing() {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
            self.spinner!.transform = CGAffineTransformRotate(self.spinner!.transform, CGFloat(M_PI_2))
            }) { (complete) -> Void in
                if (self.refreshControl!.refreshing) {
                    self.animatingRefreshing()
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        print(refreshControl?.frame)
        let y = refreshControl!.frame.origin.y
        let pct = -y / verticleDistance
        if (fabs (compass!.center.x - spinner!.center.x) > 10) {
            compass!.center.x = compass!.frame.width / 2 + pct * horizontolDistance
            spinner!.center.x = refreshView!.bounds.width - spinner!.frame.width / 2 - pct * horizontolDistance
        }
        else {
            compass!.center.x = refreshView!.frame.width / 2
            spinner!.center.x = compass!.center.x
        }
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.textLabel!.text = dataArray[indexPath.row]
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Title"
        label.textAlignment = .Center
        label.backgroundColor = UIColor.greenColor()
        return label
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

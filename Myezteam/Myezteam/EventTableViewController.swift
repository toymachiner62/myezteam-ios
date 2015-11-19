//
//  EventTableViewController.swift
//  Myezteam
//
//  Created by Caflisch, Thomas J. (Tom) on 11/18/15.
//  Copyright (c) 2015 Tom Caflisch. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {

    // MARK: Properties
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUpcomingEvents()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: (UITableView!)) -> Int {
        return 1
    }

    override func tableView(tableView: (UITableView!), numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func loadUpcomingEvents() -> Void {
        var event = Event()
        
        event.getUpcoming() {
            (upcomingEvents, error) -> Void in
        
            //println("upcomingEvents = \(upcomingEvents)")
            
            //println("FIRST EVENT = \(upcomingEvents![0])")
            
            for currentEvent in upcomingEvents! {
                
                event = Event()
                
                //println("FULL EVENT = \(currentEvent)")
                let name = currentEvent["name"] as NSString
                //println("name = \(name)")
                
                let team_id = currentEvent["team_id"] as NSNumber
                //println("team_id = \(team_id)")
                
                let start = currentEvent["start"] as NSString
                //println("start = \(start)")
                
                //println("team_id = \(currentEvent.team_id as NSString)")
                //println("start = \(currentEvent.start)")
                event.setAttributes(name, team: team_id.stringValue, time: start)
                
                println("event.game = \(event.game)")
                println("event.team = \(event.team)")
                println("event.time = \(event.time)")
                
                self.events.append(event)
            }
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> EventTableViewCell {

        let cellIdentifier = "EventTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as EventTableViewCell

        // Fetches the appropriate event for the data source layout.
        let event = events[indexPath.row]
        
        cell.gameLabel.text = event.game
        cell.teamLabel.text = event.team
        cell.timeLabel.text = event.time


        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
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
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

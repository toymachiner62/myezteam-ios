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
        
        //loadUpcomingEvents()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
//        dispatch_async(dispatch_get_main_queue()) {
//            //self.tableData = LatestWaitTimes
//            self.tableView.reloadData()
//        }
        loadUpcomingEvents()
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
    
    


    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> EventTableViewCell {
println("in tableView")
        let cellIdentifier = "EventTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as EventTableViewCell

        // Fetches the appropriate event for the data source layout.
        let event = events[indexPath.row]
        
        println("event = \(event)")
        
        cell.gameLabel.text = event.game
        cell.teamLabel.text = event.team?.name
        cell.timeLabel.text = event.time


        return cell
    }
    

    func loadUpcomingEvents() -> Void {
        var event = Event()
        var team = Team()
        var totalEvents: Int = 0
        var currentEventIndex: Int = 0
        
        
        // Get all the upcoming events
        event.getUpcoming() {
            (upcomingEvents, error) -> Void in
            
            //println("in getUpcoming callback")
            
            if(upcomingEvents != nil) {
                totalEvents = upcomingEvents!.count
                
                // Loop through all the events
                for currentEvent in upcomingEvents! {
                    currentEventIndex++
                    
                    
                    
                    //var thisEvent = Event()
                    //var thisEvent = currentEvent
                    //thisEvent.
                    //println("first currentEvent = \(thisEvent)")
                    var thisEvent = self.formatEvents(currentEvent as Dictionary)
                    //println("second thisEvent = \(thisEvent)")
                    //let name = currentEvent["name"] as NSString
                    
                    //let team_id = currentEvent["team_id"] as NSNumber
                    var team = Team()
                    
                    var team_id = thisEvent.team?.id!
                    
                    team.getTeamInfo(team_id!) {
                        (teamInfo, error) -> Void in
                        
                        //println("teamInfo = \(teamInfo!)")
                        //var teamDict = teamInfo as Dictionary<String, AnyObject>?
                        //println("name = \(teamInfo.name)")
                        //let name = teamInfo
                        //let name: String = "asdf"
                        //return name
                        
                        var teamDict = teamInfo as Dictionary?
                        //println("teamDict = \(teamDict)")
                        
                        //let name = teamDict!["name"]! as NSString
                        thisEvent.team?.name = teamDict!["name"] as NSString
                        
                        self.events.append(thisEvent as Event)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    
    


    func formatEvents(currentEvent: Dictionary<String, AnyObject>) -> Event {
        var event = Event()
        
        println("FULL EVENT = \(toString(currentEvent))")
        let name = currentEvent["name"] as NSString
        println("before")
        let start = currentEvent["start"] as NSString
        println("after")
        let team_id = currentEvent["team_id"] as NSNumber

        println("Start = \(start)")
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.dateFromString(start)
        println("date = \(date)")
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let formattedDate = dateFormatter.stringFromDate(date!)
        
        event.game = name
        event.time = formattedDate
        event.team?.id = team_id
        
        return event
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

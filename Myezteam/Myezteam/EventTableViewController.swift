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
    }
    
    override func viewWillAppear(animated: Bool) {
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
        let cellIdentifier = "EventTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EventTableViewCell

        // Fetches the appropriate event for the data source layout.
        let event = events[indexPath.row]
        
        cell.gameLabel.text = event.name
        cell.teamLabel.text = event.team.name
        cell.timeLabel.text = event.time

        return cell
    }
    
    // MARK: Functions

    /**
        Get the upcoming events
    */
    func loadUpcomingEvents() -> Void {
        
        //do {
            // Get all the upcoming events
            EventDao.getUpcoming() {
                (upcomingEvents, error) -> Void in
            
                if(upcomingEvents != nil) {
            
                    // Loop through all the events
                    for currentEvent in upcomingEvents! {
                
                        let name = currentEvent["name"] as! NSString
                        let start = currentEvent["start"] as! NSString
                        let teamId = currentEvent["team_id"] as! Int

                        // Format date format
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let date = dateFormatter.dateFromString(start as String)
                        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                        let formattedDate = dateFormatter.stringFromDate(date!)
                        
                        do {
                            try TeamDao.getTeamInfo(teamId) {
                                (teamInfo, error) -> Void in
                                
                                var teamDict = teamInfo as Dictionary?
                                let teamName = teamDict!["name"]! as! NSString
                                let team = Team(id: teamId, name: teamName as String)
                                let event = Event(name: name as String, team: team, time: formattedDate)
                                
                                self.events.append(event)
                                
                                // Sort the array b/c it loses order probably due to the TeamDao.getTeamInfo async method
                                self.events.sortInPlace{(event1:Event, event2:Event) -> Bool in
                                 event1.time < event2.time
                                }
                                
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.tableView.reloadData()
                                }
                            }
                        } catch {
                            print("Error fetching teamInfo")
                        }
                    }
                }
            }
        
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

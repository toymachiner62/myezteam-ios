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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        cell.descriptionLabel.text = event.description
        cell.myResponseLabel.text = event.myResponse
        
        cell.myResponseLabel.backgroundColor = setTextColor(cell.myResponseLabel.text!)
        cell.myResponseLabel.layer.cornerRadius = 4
        
        // Gradient colors
        let topColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
        let bottomColor = UIColor(red: (92/255.0), green: (92/255.0), blue: (92/255.0), alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        gradientLayer.frame = cell.bounds
        //gradientLayer.frame = self.view.bounds
        //self.tableView.layer.insertSublayer(gradientLayer, atIndex: 0)
        cell.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        //let separator = UIView()
        //separator.backgroundColor = UIColor(red: (60/255.0), green: (60/255.0), blue: (60/255.0), alpha: 1)
        
        //cell.addSubview(separator)
        
        
        let additionalSeparatorThickness = CGFloat(1)
        let topDarkSeparator = UIView(frame: CGRectMake(0,
            cell.frame.size.height - additionalSeparatorThickness,
            cell.frame.size.width - 90,
            additionalSeparatorThickness))
        
        let bottomDarkSeparator = UIView(frame: CGRectMake(1,
            cell.frame.size.height,
            cell.frame.size.width - 90,
            additionalSeparatorThickness))
        
        let topLightSeparator = UIView(frame: CGRectMake(0,
            cell.frame.size.height - additionalSeparatorThickness,
            90,
            additionalSeparatorThickness))
        
        let bottomLightSeparator = UIView(frame: CGRectMake(1,
            cell.frame.size.height,
            88,
            additionalSeparatorThickness))
        

        topDarkSeparator.frame.insetInPlace(dx: CGFloat(-90), dy: CGFloat(0))
        bottomDarkSeparator.frame.insetInPlace(dx: CGFloat(-90), dy: CGFloat(0))
        //topLightSeparator.frame.insetInPlace(dx: CGFloat(0), dy: CGFloat(0))
        bottomLightSeparator.frame.insetInPlace(dx: CGFloat(-1), dy: CGFloat(0))
        
        if(indexPath.row + 1 != events.count) {
        
            topDarkSeparator.backgroundColor = UIColor(red: (80/255.0), green: (80/255.0), blue: (80/255.0), alpha: 1)
            cell.addSubview(topDarkSeparator)
            
            bottomDarkSeparator.backgroundColor = UIColor(red: (95/255.0), green: (95/255.0), blue: (95/255.0), alpha: 1)
            cell.addSubview(bottomDarkSeparator)
            
            topLightSeparator.backgroundColor = UIColor(red: (245/255.0), green: (245/255.0), blue: (245/255.0), alpha: 1)
            cell.addSubview(topLightSeparator)
            
            bottomLightSeparator.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
            cell.addSubview(bottomLightSeparator)
        }
        
        
        
        
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
                        let eventDescription = currentEvent["description"] as? String
                        let eventId = currentEvent["id"] as! Int

                        // Format date format
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let date = dateFormatter.dateFromString(start as String)
                        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                        let formattedDate = dateFormatter.stringFromDate(date!)
                        
                        
                        self.getTeamInfo(teamId) {
                            (team, err) -> Void in
                            
                            self.getMyResponseForEvent(eventId) {
                                (response, err) -> Void in
                                
                                print(eventDescription)
                                
                                var event: Event
                                
                                if (response == nil) {
                                    event = Event(name: name as String, team: team!, time: formattedDate, description: eventDescription ?? "", myResponse: "No Response")
                                } else {
                                    event = Event(name: name as String, team: team!, time: formattedDate, description: eventDescription ?? "", myResponse: response!)
                                }
                                
                                // Sort the array b/c it loses order probably due to the TeamDao.getTeamInfo async method
                                self.events.sortInPlace{(event1:Event, event2:Event) -> Bool in
                                    event1.time < event2.time
                                }
                                
                                self.events.append(event)
                                
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.tableView.reloadData()
                                }
                                
                            }
                            
                            
                        }
//                        do {
//                            try TeamDao.getTeamInfo(teamId) {
//                                (teamInfo, error) -> Void in
//                                
//                                var teamDict = teamInfo as Dictionary?
//                                let teamName = teamDict!["name"]! as! NSString
//                                let team = Team(id: teamId, name: teamName as String)
//                                let event = Event(name: name as String, team: team, time: formattedDate)
//                                
//                                self.events.append(event)
//                                
//                                // Sort the array b/c it loses order probably due to the TeamDao.getTeamInfo async method
//                                self.events.sortInPlace{(event1:Event, event2:Event) -> Bool in
//                                    event1.time < event2.time
//                                }
//                                
//                                dispatch_async(dispatch_get_main_queue()) {
//                                    self.tableView.reloadData()
//                                }
//                            }
//                        } catch {
//                            print("Error fetching teamInfo")
//                        }
                    }
                }
            }
        
    }
    
    /**
        Gets a team's info based on a team id
    */
    func getTeamInfo(teamId: Int, callback: (Team?, String?) -> Void) {
        do {
            try TeamDao.getTeamInfo(teamId) {
                (teamInfo, error) -> Void in
                
                var teamDict = teamInfo as Dictionary?
                let teamName = teamDict!["name"]! as! NSString
                let team = Team(id: teamId, name: teamName as String)
                //let event = Event(name: name as String, team: team, time: formattedDate)
                
                callback(team, nil)
            }
        } catch {
            print("Error fetching teamInfo")
        }
    }
    
    /**
        Gets a team's info based on a team id
     */
    func getMyResponseForEvent(eventId: Int, callback: (String?, String?) -> Void) {
        do {
            try ResponseDao.getMineForEvent(eventId) {
                (responses, error) -> Void in
                
                //var teamDict = teamInfo as Dictionary?
                //let teamName = teamDict!["name"]! as! NSString
                //let team = Team(id: teamId, name: teamName as String)
                //let response = responses![0] as! Dictionary<String, NSObject>
                //print("responses = ")
                //print(responses)
                
                print("")
                print("")
                
                print("responses = ")
                print(responses)
                
                //if let response: NSDictionary = responses![0] as? NSDictionary where !responses.isEmpty {
                let responses = responses as Array?
                if(!responses!.isEmpty) {
                    let response = responses![0]
                    
                    print("single response = ")
                    print(response["created"])
                    print(response["response"]!!["label"]!)
                    
                    callback(response["response"]!!["label"]! as! String?, nil)
                } else {
                    callback(nil, nil)
                }
                
                
                //let event = Event(name: name as String, team: team, time: formattedDate)
                
                //print(response)
                
                //callback(response as! Dictionary<String, NSObject>, nil)
            }
        } catch {
            print("Error fetching responses")
        }
    }
    
    /**
        Return a color based on the response
     */
    func setTextColor(response: String) -> UIColor {
        if(response == "No Response") {
            return UIColor.darkGrayColor()
        } else if(response == "Yes") {
            return UIColor.greenColor()
        } else if(response == "Probably") {
            return UIColor.yellowColor()
        } else if(response == "Maybe") {
            return UIColor.orangeColor()
        } else if(response == "No") {
            return UIColor.redColor()
        } else {
            return UIColor.darkGrayColor()
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

//
//  teacherStudentSelectionTableViewController.swift
//  class-companion
//
//  Created by Jonathan Davis on 7/21/15.
//  Copyright (c) 2015 Jonathan Davis. All rights reserved.
//

import UIKit

class teacherStudentSelectionTableViewController: TeacherStudentsTableViewController {

  
    override func viewDidLoad() {
        super.viewDidLoad()

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

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

  override func setUpNavBarTitle() {
    self.title = "\(currentClassName!) Selection"
  }
  
  
  // MARK: - Table logic
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCellWithIdentifier("teacherStudentSelectionCell", forIndexPath: indexPath) as! UITableViewCell

      let currentRow = indexPath.row
      
      let selectedStudent = allTeacherStudents[currentRow]
      
      cell.textLabel?.text = selectedStudent.studentTitle
      
      if selectedStudent.currentlySelected {
        cell.detailTextLabel?.text = "Selected!"
      } else {
        cell.detailTextLabel?.text = ""
      }

      return cell
    }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    let row = indexPath.row
    
    setStudentAsSelected(row)
   
  }
  
  // MARK: - Buttons
  
  @IBAction func randomSelectionButton(sender: UIBarButtonItem){
      let randomIndex = getRandomRowIndex()
    
      setStudentAsSelected(randomIndex)
  }
  
  // MARK: - Random Selection
  func getRandomRowIndex() -> Int {
    let randomRowIndex = Int(arc4random_uniform(UInt32(allTeacherStudents.count)))
    
    return randomRowIndex
  }
  
  // stores the previously selected student index
  // used for removing the "Selected!" message from the detail
  var previousSelectionRow: Int?
  
  func setStudentAsSelected(selectedStudentIndex: Int) {
    // if we previously set a student selection
    if let previousSelectionIndex = previousSelectionRow {
      // set the previous student model's selection status to false
      allTeacherStudents[previousSelectionIndex].currentlySelected = false
      // get the index path for the previous random selection
      let previousCellIndexPath = NSIndexPath(forRow: previousSelectionIndex, inSection: 0)
      // reload the random path selection
      self.tableView.reloadRowsAtIndexPaths([previousCellIndexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    allTeacherStudents[selectedStudentIndex].currentlySelected = true
    
    let cellToEditIndexPath = NSIndexPath(forRow: selectedStudentIndex, inSection: 0)
    
    self.tableView.reloadRowsAtIndexPaths([cellToEditIndexPath], withRowAnimation: UITableViewRowAnimation.None)
    
    self.tableView.selectRowAtIndexPath(cellToEditIndexPath, animated: true, scrollPosition: .Middle);
    
    previousSelectionRow = selectedStudentIndex
    
    sendSelectedStudent(allTeacherStudents[selectedStudentIndex])
  }
  
  func setRandomStudentAsSelected() {
    

 
  }
  
  // MARK: - Firebase Send Student Selection Info
  
  func sendSelectedStudent(selectedStudent: TeacherStudent) {
    let studentId = selectedStudent.studentId
    
    let firebaseStudentRef =
    firebaseClassRootRef
      .childByAppendingPath(currentClassId)
      .childByAppendingPath("selection/")
    
    let selectionInfo = ["currentSelection": studentId]
    
    firebaseStudentRef.setValue(selectionInfo)
    
    
  }
  

  
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
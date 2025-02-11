//
//  main.swift
//  inventory
//
//  Created by StudentPM on 1/27/25.
//

import Foundation
import CSV
 
//empty 2D arrays to store data
var students: [[String]] = [] //store student names and their scores
//empty 2D arrays to store data
var names: [String] = [] //store student names
var scores: [[String]] = [] //store scores for each student
var finalScore: [Double] = [] //to store the final computed scores (averages) of students
 
do{
    //open cvs file
    let stream = InputStream(fileAtPath: "/Users/studentpm/Desktop/GradeManagement/inventory/inventory/schoolList.csv")
    //create csv reader to see the data inside
    let csv = try CSVReader(stream: stream!)
    //Loop through each row in the CSV file
    while let row = csv.next(){
        handleData(data: row)
    }
}
catch{
    // Catches and prints an error message if file reading fails
    print("there was an error")
}

 
// Function to process each row of data from the CSV file
func handleData(data: [String]){
    var tempScores: [String] = [] // Temporary array to store scores for a single student
    

    // Loops through each value in the row
    for i in data.indices{
        if i == 0{
            // The first value (index 0) is assumed to be the student's name, so it's added to `names`
            names.append(data[i])
        }
        else{
            // Remaining values are treated as scores and added to `tempScores`
            tempScores.append (data[i])
        }
    }
    
    scores.append(tempScores)
    var sum: Double = 0.0 // Variable to store the sum of scores
    var tempFinalScore: Double = 0.0 // Variable to store the student's final average score

    for score in tempScores{
        if let score = Double(score){
            sum += score
        }
    }
    tempFinalScore = sum / Double (tempScores.count)
    finalScore.append(tempFinalScore)
}

// Main program loop control
var isRunning = true // Determines if the program should keep running
while isRunning {
    mainMenu()  // Display main menu
}
    
// Function to display the main menu and process user input
func mainMenu(){
    print("Welcome to the Grade Manager!")
    print("")
    print("What would you like to do? (Enter the number):")
    print("1. Display grade of a single student")
    print("2. Display all grades for a student")
    print("3. Display all grades of ALL students")
    print("4. Find the average grade of the class")
    print("5. Find the average grade of an assignment")
    print("6. Find the lowest grade in the class")
    print("7. Find the highest grade of the class")
    print("8. Filter students by grade range")
    print("9. Quit")
    
    if let userInput = readLine(){
        // Call respective functions based on user input
        if userInput == "1"{
            singleGrade() 
        } else if userInput == "2"{
            allGrades()
        } else if userInput == "3"{
            allGradesStudents()
        } else if userInput == "4"{
            avrgGradeClass()
        } else if userInput == "5"{
            avrgGradeAsgmt()
        } else if userInput == "6"{
            lwstGrade()
        } else if userInput == "7"{
            hgstGrade()
        } else if userInput == "8"{
            studentRange()
        } else if userInput == "9"{
            quit()
            isRunning = false // End program after quitting
        } else {
            print("Please choose an appropriate option!")
            }
        }
}

// Function to display a single student's final grade
func singleGrade(){
    var index:Int = -1  // Initialize index to -1 to track if the student is found
    
    print("Which student would you like to choose?")  // Prompt user for student name

    if let itemInput = readLine(){  // Read user input

        for i in names.indices{  // Loop through all student names
            if itemInput == names[i]{  // Check if input matches a student name
                index = i  // Store index of found student
                print("\(names[index])'s grade in the class is \(finalScore[index]).") // Print student's final grade
            }
        }
        if index == -1 { // If student is not found
            print("Student not found. Please try again.")  // Print error message
        }
    }
}

// Function to display all grades of a selected student
func allGrades(){
    var index:Int = -1 // Initialize index to track if the student is found

    print("Which student would you like to choose?") // Prompt user for student name

    if let itemInput = readLine(){ // Read user input
        for i in names.indices{ // Loop through student names
            if itemInput == names[i]{ // Check if input matches a student name
                index = i // Store index of found student
            }
        }
        if index != -1{ // If student is found
            print("\(names[index])'s grades for this class are: ", terminator: "") // Print student name
            for score in scores[index]{ // Loop through student’s scores
                print(score + " ", terminator: "") // Print each score with a space
            }
        }
        else{ // If student is not found
            print("Student not found. Please try again.") // Print error message
        }
    }
}

// Function to display all students' grades
func allGradesStudents(){
    for i in names.indices{ // Loop through all students
        print("\(names[i])'s grades for this class are: ", terminator: "") // Print student name
        for score in scores[i]{ // Loop through their scores
            print(score + " ", terminator: "") // Print each score with a space
        }
        print("") // Print new line after each student's grades
    }
}
  
// Function to calculate and display class average
func avrgGradeClass(){
    var totalSum: Double = 0.0  // Variable to store the sum of all final scores
    var totalCount: Int = 0 // Counter for the number of students

       // Loop through all final scores
       for i in finalScore.indices { // Loop through all final scores
           totalSum += finalScore[i] // Add each score to total sum
           totalCount += 1 // Increment the count of students
       }

       if totalCount > 0 { // Ensure there are students before calculating average
           let classAverage = totalSum / Double(totalCount) // Compute average score
           print("The class average is: \(String(format:"%.2f" ,classAverage))") // Print formatted class average
       } else {
           print("No student data available to calculate the average.") // Print message if no data
       }
}

// Function to calculate and display assignment average
func avrgGradeAsgmt(){
    print("Which assignent would you like to get the average of (1-10):")  // Prompt user for assignment number
    
    if let itemInput = readLine(), let index = Int(itemInput){  // Read input and convert to integer
        if index > 0 && index < 11{ // Ensure valid assignment number
            
            var sum: Double = 0.0  // Variable to store sum of assignment scores
            
            for studentScore in scores{ // Loop through all students’ scores
                if let studentScore = Double(studentScore[index-1]){ // Convert score to Double
                    sum += studentScore // Add score to sum
                }
            }
            let average: Double = sum/Double(scores.count) // Compute average score
            print("The average for assignment #\(index) is \(String(format:"%.2f",average))")
        }
    }
}


// Function to find and display the lowest grade in the class
func lwstGrade(){
    
    var lowest: Double = finalScore[0] // Assume first student has the lowest grade initially
    var lowestName: String = ""  // Variable to store student with lowest grade
    
    for i in finalScore.indices{  // Loop through all final scores
        if finalScore[i] < lowest{  // If a lower grade is found
            lowest = finalScore[i]  // Update lowest grade
            lowestName = names[i]   // Store student name
        }
        
    }
    print("\(lowestName) is the student with the lowest grade: \(lowest)") // Print lowest grade info
}

// Function to find and display the highest grade in the class
func hgstGrade(){
    
    var highest: Double = finalScore[0] // Assume first student has highest grade initially
    var highestName: String = ""        // Variable to store student with highest grade
    
    for i in finalScore.indices{    // Loop through all final scores
        if finalScore[i] > highest{ // If a higher grade is found
            highest = finalScore[i] // Update highest grade
            highestName = names[i]  // Store student name
        }
        
    }
    print("\(highestName) is the student with the highest grade: \(highest)")
}

// Function to filter students by grade range
func studentRange(){
    
    
    print("Enter the low range you would like to use:") // Prompt for low range
    if let lowestIndex = readLine(), let lowest = Double(lowestIndex){ // Read input and convert to Double
        print("Enter the high range you would like to use:") // Prompt for high range
        
        if let highestIndex = readLine(), let highest = Double(highestIndex){ // Read input and convert to Double
            if highest <= lowest{  // If high range is not greater than low range
                mainMenu() // Return to main menu
            }
            for i in finalScore.indices{  // Loop through all students
                if finalScore[i] > lowest && finalScore[i] < highest{ // Check if grade is in range
                    print("\(names[i]): \(String(format:"%.2f",finalScore[i]))") // Print student's grade
                }
            }
                
        }
    }
    
}
  
// Function to quit the program
func quit(){
    print("Have a great rest of your day!") // Print exit message
}


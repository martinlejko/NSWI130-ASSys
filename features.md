# Enrollments

## Core features and responsibilities

### Feature 1: Student enrolling to a subject

As a student, I want to enroll to subject because I want to get credits.

#### Breakdown

- Student opens dashboard
- Student selects subject enrollment button
- Student filters out desired subject
- Student selects desired subject and clicks enroll button
- System checks prerequisities and capacity
- If the subject capacity is full, student is not allowed to enroll
- If the check is successful, student is informed about success and is enrolled to subject

#### Responsibilities

### Feature 2: Study department checking prerequisites

As a study department, I want to check prerequisites in order to let eligible people enroll.

#### Breakdown

- Student opens dashboard
- Student selects his schedule
- Student selects desired subject
- Student see the subject page
- Student selects sign off subject
- System checks if student can sign off
- If yes the sign off is successful, student is informed about this action
- If no student can not sing off the subject
- Student can inform teacher about his situation and teacher can sing off the student

#### Responsibilities


### Feature 3: Student signing off from a subject

As a student, I want to sign off the subject, because I do not have time for it.

#### Breakdown

- Student opens dashboard    
- Student selects subject management button 
- Student selects a subject to sign off 
- Student clicks the "Sign Off" button 
- System checks eligibility for sign-off. The system verifies if the student is eligible to sign off based on any constraints, such as:  
  - Deadline for subject sign-off has not passed
  - The subject is not a core or mandatory subject that cannot be dropped
- If sign-off is not allowed
  - The student is informed about the reason (e.g., deadline missed, mandatory subject) and cannot proceed
- If sign-off is allowed 
  - The system removes the subject from the student’s enrolled list
  - The subject capacity (if applicable) is updated to allow other students to enroll 
  - The system updates the student's academic progress to reflect the change
- Student is informed about the successful sign-off

#### Responsibilities


### Feature 4: Student viewing Enrolled Subjects

As a student, I want to view my enrolled subjects, because I need to keep track of my academic progress and ensure Im meeting my degree requirements.

#### Breakdown

- Student opens dashboard.
- Student selects the "My Enrollments" button.
- System displays a list of all enrolled subjects.
- Student can filter or search through the subjects if needed.
- For each subject, student can see atleast:
  - Subject name
  - Credits
  - Current status (active, completed, withdrawn)
- Student can click on a subject to view more details, including course syllabus and grades (if available).

#### Responsibilities

### Feature 5: Teacher notifying enrolled students

As a teacher, I want to send messages to whole group, because I want to give students important information.

#### Breakdown

- Teacher opens dashboard
- Teacher selects the "My Subjects" section
- System shows list of subjects that the teacher teaches or empty list
- Teacher selects the appropriate subject
- System shows more detailed info panel about the subject
- Teacher clicks on the "Message enrolled students" button
- System shows two editable text areas, one for subject other for the content, and a "Send" button
- Teacher fills the areas with appropriate text and clicks the "Send" button
- System shows confirmation toast that the message has been sent and sends the message

#### Responsibilities

### Feature 6: Generating Statistical Reports for Subject Success Rates (Matúš Klečka)

As a manager, I want to generate statistical reports, because I want to see success rates of the subject in time.

#### Breakdown

- Manager logs into the system dashboard.
- Manager navigates to the "Reports" or "Analytics" section.
- System displays various report options.
- Manager selects "Subject Success Rates" report.
- System prompts for report parameters (time period, subjects).
- Manager sets desired parameters and clicks "Generate Report."
- System generates and displays the statistical report.
- Manager reviews the report and has options to download, print, or share it.

#### Responsibilities

### Feature 7: Joining a Waiting List for a Full Course (Martin Lejko)

As a student, I want to join a waiting list if the capacity is full for the course I want to enroll in, because I still want a chance to get into the course if space becomes available.

#### Breakdown

- Student opens dashboard.
- Student selects the "Subject Enrollment" button.
- Student filters or searches for the desired subject.
- Student selects the desired subject and clicks the "Enroll" button.
- System checks prerequisites and the capacity of the subject.
- If the subject capacity is full, system displays a notification informing the student.
- Student is given the option to join a waiting list for the subject.
- Student confirms they want to join the waiting list.
- System adds the student to the waiting list and informs them of their position in the queue.
- If space becomes available, system notifies the student that they are enrolled.

#### Responsibilities


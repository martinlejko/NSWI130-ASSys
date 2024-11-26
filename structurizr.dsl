workspace "ENR System Workspace" "This workspace documents the architecture of the Enrollment (ENR) system." {

    model {
        usr_login_system = softwareSystem "User Logins (USRLOG)" "Handles authentication of the users." "Existing Systems"
    
        enr_system = softwareSystem "Enrollments (ENR)" "Handles student enrollments and communications." {
            webApp = container "Web Application" "Interface for stakeholders to access ENR functionalities" "Web Front-End" {
                userInterface = component "User Interface" "Provides interface for user interactions"
            }

            statisticsManager = container "Statistics Manager" "Generates and works with course statistics" {
                report_controller = component "Report Controller" "Handles requests for generating statistical reports" 
                reportRepository = component "Report Repository" "Stores report configurations and results"
            }
            
            log_database = container "Statistics Log Database" "Stores statistics of courses based on historical data" "SQL" "Database"
            

            enrollmentManager = container "Enrollment Manager" "Manages the enrollment logic" {
                student_controller = component "Student Controller" "Handles requests related to student profiles"
                teacher_controller = component "Teacher Controller" "Handles requests related to teacher interactions"
                department_controller = component "Department Controller" "Handles requests related to department tasks"
                
                enrollment_processor = component "Enrollment Processor" "Processes enrollment requests and interactions with the database"
                prerequisites_validator = component "Prerquisites Validator" "Validated if subject prerequisites have been met"
                enrollment_viewer = component "Enrollment Viewer" "Handels basic viewing of the enrolled subjects"
                notification_manager = component "Notification Manager" "Notifies students enrolled in courses"
                enrollment_repository = component "Enrollment Repository" "Stores and retrieves enrollment data"
            }
            
            enrollment_database = container "Enrollment Database" "Stores information about courses and enrollments" "SQL" "Database" 

            userInterface -> student_controller "Submits student-related requests to"
            userInterface -> teacher_controller "Submits teacher-related requests to"
            userInterface -> department_controller "Submits department-related requests to"
            userInterface -> report_controller "Requests reports from"

            student_controller -> enrollment_processor "Forwards student enroll requests to"
            student_controller -> enrollment_viewer "Forwards students request for already enrolled subjects"
            teacher_controller -> enrollment_processor "Forwards teacher enroll requests to"
            department_controller -> enrollment_processor "Forwards department requests to"
            
            teacher_controller -> notification_manager "Uses for notifications to students"
            department_controller -> notification_manager "Uses for notifications to students"
            department_controller -> prerequisites_validator "Requests validation of student prerequisites"
            

            enrollment_repository -> enrollment_database "Reads from and writes to"
            reportRepository -> log_database "Communicates with"
            
            enrollment_viewer -> enrollment_repository "Gets enrollment data"
            notification_manager -> enrollment_repository "Gets enrolled student information"
            enrollment_processor -> enrollment_repository "Reads and writes enrollment data"
            prerequisites_validator -> enrollment_repository "Reads enrollment data"
            report_controller -> enrollment_repository "Reads from"
            report_controller -> reportRepository "Writes to"
            
            enrollmentManager -> webApp "Notifies enrolled students on teacher request"
        }

        student = person "Student" "Enrolled in courses and communicates with study department."
        teacher = person "Teacher" "Enters student enrollments and views reports."
        study_department_officer = person "Study Department Officer" "Manages student records and verifies enrollments."
        manager = person "Manager" "Oversees enrollments and generates statistical reports."

        student -> webApp "Accesses for enrollment and information"
        teacher -> webApp "Accesses for managing student enrollments"
        study_department_officer -> webApp "Accesses for record verification"
        manager -> webApp "Generates reports"
        
        enr_system -> usr_login_system "Uses for user login"
        webApp -> usr_login_system "Authenticates users with"
        
        deploymentEnvironment "Production" {
            prod_user = deploymentNode "User's Device" "Device used by the student" "Web Browser" {
                prod_webApp = containerInstance webApp
            }

            prod_cloud = deploymentNode "Cloud Hosting Environment" "Cloud infrastructure hosting the application" "AWS" {
                prod_statisticsManager = deploymentNode "Statistics Manager Server" "Processes course statistics" "EC2 Instance" {
                    prod_statisticsManager_instance = containerInstance statisticsManager
                }
                prod_enrollmentManager = deploymentNode "Enrollment Manager Server" "Handles enrollment operations" "EC2 Instance" {
                    prod_enrollmentManager_instance = containerInstance enrollmentManager
                }
                prod_database = deploymentNode "Database Server" "Hosts the databases" "RDS Instance" {
                    prod_enrollmentDatabase = containerInstance enrollment_database
                    prod_logDatabase = containerInstance log_database
                }
            }
        }
        
        deploymentEnvironment "Testing" {
            test_user = deploymentNode "User's Device" "Device used by the student" "Web Browser" {
                test_webApp = containerInstance webApp
            }
            
            test_statisticsManager = deploymentNode "Statistics Manager Server" "Processes course statistics" "Ubuntu 18.04 LTS" {
                test_statisticsManager_instance = containerInstance statisticsManager
            }
            test_enrollmentManager = deploymentNode "Enrollment Manager Server" "Handles enrollment operations" "Ubuntu 18.04 LTS" {
                test_enrollmentManager_instance = containerInstance enrollmentManager
            }
            test_database = deploymentNode "Database Server" "Hosts the databases" "Elasticsearch 8.14" {
                test_enrollmentDatabase = containerInstance enrollment_database
                test_logDatabase = containerInstance log_database
            }
        }
        
    }

    views {
        systemContext enr_system "enr_system_context_diagram" {
            include *
            autolayout tb
        }

        container enr_system "enr_system_container_diagram" {
            include *

        }

        component enrollmentManager "enrollmentManager_component_diagram" {
            include *
            autolayout tb
        }

        component webApp "webApp_component_diagram" {
            include *
            autolayout tb
        }

        component statisticsManager "statisticsManager_component_diagram" {
            include *
            autolayout tb
        }
        
        deployment enr_system "Production" "Production_Deployment" {
            include *
            autolayout tb
        }
        
        deployment enr_system "Testing" "Testing_Deployment" {
            include *
            autolayout tb
        }
        
        //Martin Lejko
        dynamic enr_system "WaitingListProcess" {
            description "(Martin Lejko) The sequence of actions for a student joining a waiting list for a full course."
        
            student -> webApp "Opens the dashboard"
            student -> webApp "Selects subject enrollment button"
            student -> webApp "Filters desired subject"
            student -> webApp "Selects subject and clicks enroll"
            webApp -> enrollmentManager "Checks prerequisites and capacity"
            enrollmentManager -> webApp "Returns full capacity status"
            webApp -> student "Displays full capacity notification"
            student -> webApp "Chooses to join waiting list"
            webApp -> enrollmentManager "Requests waiting list addition"
            enrollmentManager -> enrollment_database "Updates waiting list"
            enrollmentManager -> webApp "Returns queue position"
            webApp -> student "Shows waiting list confirmation"
            enrollmentManager -> webApp "Sends availability notification"
            webApp -> student "Notifies of available spot"
        
            autolayout tb
        }
        //Daniel Lopata
        dynamic enr_system "StudentEnrollmentProcess" {
            description "(Daniel Lopata) The sequence of actions for a student enrolling in a subject."
        
            student -> webApp "Opens the dashboard"
            student -> webApp "Selects subject enrollment button"
            student -> webApp "Filters desired subject"
            student -> webApp "Selects subject and clicks enroll"
            webApp -> enrollmentManager "Checks prerequisites and capacity"
            enrollmentManager -> enrollment_database "Verifies subject capacity and prerequisites"
            enrollmentManager -> webApp "Returns enrollment success or failure status"
        
            webApp -> student "Notifies about success and enrollment confirmation or failure"
        
            autolayout tb
        }
        // Samuel Koribanic
        dynamic enr_system "ViewEnrolledSubjects" {
            description "(Samuel Koribanic) The sequence of actions for a student viewing their enrolled subjects."
        
            student -> webApp "Opens the dashboard"
            student -> webApp "Selects the 'My Enrollments' button"
            webApp -> enrollmentManager "Requests list of enrolled subjects"
            enrollmentManager -> enrollment_database "Fetches enrolled subjects for the student"
            enrollment_database -> enrollmentManager "Returns enrolled subjects data"
            enrollmentManager -> webApp "Provides list of enrolled subjects"
            webApp -> student "Displays enrolled subjects with filters and search options"
            
            student -> webApp "Filters or searches through enrolled subjects (optional)"
            student -> webApp "Selects a subject for details"
            webApp -> enrollmentManager "Requests detailed information for selected subject"
            enrollmentManager -> enrollment_database "Retrieves syllabus and grade details if available"
            enrollment_database -> enrollmentManager "Returns detailed subject information"
            enrollmentManager -> webApp "Displays subject details, including syllabus and grades"
            
            autolayout tb
        }
        //David Petera
        dynamic enr_system "EmailingStudents" {
            description "(David Petera) The sequence of action of a teacher that wants to send email to whole group of enrolled students."
            
            teacher -> webApp "Teacher opens the dashboard"
            teacher -> webApp "Teacher selects the 'My Subjects' section"
            webApp -> enrollmentManager "Backend gets the data from the database"
            webApp -> teacher "System shows list of subjects that the teacher teaches or empty list"
            // if "List of subject not empty" 
            teacher -> webApp "Teacher selects the appropriate subject"
            webApp -> teacher "System shows more detailed info panel about the subject"
            teacher -> webApp "Teacher clicks on the 'Message enrolled students' button"
            webApp -> teacher "System shows two editable text areas, one for subject other for the content, and a 'Send' button"
            teacher -> webApp "Teacher fills the areas with appropriate text and clicks the 'Send' button"
            webApp -> enrollmentManager "Sends the data to the backend"
            webApp -> student "Sends email to the students"
            webApp -> teacher "System shows confirmation toast that the message has been sent"
            
            autolayout tb
        }
        //Matus Klecka
        dynamic statisticsManager "GeneratingStatisticalReports" {
            description "(Matus Klecka) The sequence of actions within the Statistics Manager for generating statistical reports on subject success rates over time."
        
            report_controller -> reportRepository "Fetches report configurations and available reports"
            reportRepository -> log_database "Retrieves historical data for reports"
            log_database -> reportRepository "Returns historical data"
            reportRepository -> report_controller "Returns report data"
            report_controller -> webApp "Sends the generated report"
        
            autolayout tb
        }

        // Adam Budai
        dynamic statisticsManager "StatisticsManager_ComponentInteractions" {
            description "(Adam Budai) The sequence of actions within the Statistics Manager for generating statistical reports."

            report_controller -> reportRepository "Fetches and stores report configurations and results"
            reportRepository -> log_database "Retrieves historical data for reports"
            reportRepository -> report_controller "Returns report data"

            autolayout tb
        }

        theme default

        styles {
            element "Web Front-End" {
                shape WebBrowser
            }
            element "Database" {
                shape Cylinder
            }
            element "Existing Systems" {
                background #999999
                color #ffffff
            }
        }
    }
}

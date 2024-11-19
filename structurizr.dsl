workspace "ENR System Workspace" "This workspace documents the architecture of the Enrollment (ENR) system." {

    model {
        usr_login_system = softwareSystem "User Logins (USRLOG)" "Handels authentification of the users." "Existing Systems"
    
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
                notification_manager = component "Notification Manager" "Notifies students enrolled in courses"
                enrollment_repository = component "Enrollment Repository" "Stores and retrieves enrollment data"
            }
            
            enrollment_database = container "Enrollment Database" "Stores information about courses and enrollments" "SQL" "Database" 

            userInterface -> student_controller "Submits student-related requests to"
            userInterface -> teacher_controller "Submits teacher-related requests to"
            userInterface -> department_controller "Submits department-related requests to"
            userInterface -> report_controller "Requests reports from"

            student_controller -> enrollment_processor "Forwards student enroll requests to"
            teacher_controller -> enrollment_processor "Forwards teacher enroll requests to"
            department_controller -> enrollment_processor "Forwards department requests to"
            //reportController -> statistics_manager "Requests reports from"
            
            teacher_controller -> notification_manager "Uses for notifications to students"
            department_controller -> notification_manager "Uses for notifications to students"
            //reportController -> statistics_manager "Uses for report generation"

            enrollment_repository -> enrollment_database "Reads from and writes to"
            reportRepository -> log_database "Communicates with"

            notification_manager -> enrollment_repository "Gets enrolled student information"
            enrollment_processor -> enrollment_repository "Reads and writes enrollment data"
            report_controller -> enrollment_repository "Reads from"
            report_controller -> reportRepository "Writes to"
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
            test_user = deploymentNode deploymentNode "User's Device" "Device used by the student" "Web Browser" {
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
        }

        container enr_system "enr_system_container_diagram" {
            include *
        }

        component enrollmentManager "enrollmentManager_component_diagram" {
            include *
        }

        component webApp "webApp_component_diagram" {
            include *
        }

        component statisticsManager "statisticsManager_component_diagram" {
            include *
        }
        
        deployment enr_system "Production" "Production_Deployment" {
            include *
        }
        
        deployment enr_system "Testing" "Testing_Deployment" {
            include *
        }
        
        
        dynamic enr_system "WaitingListProcess" {
            description "The sequence of actions for a student joining a waiting list for a full course."
        
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
        
            autolayout lr
        }
        
        dynamic enr_system "StudentEnrollmentProcess" {
            description "The sequence of actions for a student enrolling in a subject."
        
            student -> webApp "Opens the dashboard"
            student -> webApp "Selects subject enrollment button"
            student -> webApp "Filters desired subject"
            student -> webApp "Selects subject and clicks enroll"
            webApp -> enrollmentManager "Checks prerequisites and capacity"
            enrollmentManager -> enrollment_database "Verifies subject capacity and prerequisites"
            enrollmentManager -> webApp "Returns enrollment success or failure status"
        
            webApp -> student "Notifies about success and enrollment confirmation or failure"
        
            autolayout lr
        }

        dynamic enr_system "ViewEnrolledSubjects" {
            description "The sequence of actions for a student viewing their enrolled subjects."
        
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
            
            autolayout lr
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

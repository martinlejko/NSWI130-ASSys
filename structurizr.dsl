workspace "ENR System Workspace" "This workspace documents the architecture of the Enrollment (ENR) system." {

    model {
        enr_system = softwareSystem "Enrollments (ENR)" "Handles student enrollments and communications." {
            webApp = container "Web Application" "Interface for stakeholders to access ENR functionalities" "Web Front-End" {
                userInterface = component "User Interface" "Provides interface for user interactions"
            }

            statisticsManager = container "Statistics Manager" "Generates and works with course statistics" {
                report_controller = component "Report Controller" "Handles requests for generating statistical reports" 
                log_database = component "Statistics Log Database" "Stores statistics of courses based on historical data" "SQL" "Database" 
                reportRepository = component "Report Repository" "Stores report configurations and results"
            }
            

            enrollmentManager = container "Enrollment Manager" "Manages the enrollment logic" {
                student_controller = component "Student Controller" "Handles requests related to student profiles"
                teacher_controller = component "Teacher Controller" "Handles requests related to teacher interactions"
                department_controller = component "Department Controller" "Handles requests related to department tasks"
                
                enrollment_processor = component "Enrollment Processor" "Processes enrollment requests and interactions with the database"
                notification_manager = component "Notification Manager" "Notifies students enrolled in courses"
                enrollment_repository = component "Enrollment Repository" "Stores and retrieves enrollment data"
                enrollment_database = component "Enrollment Database" "Stores information about courses and enrollments" "SQL" "Database" 
            }
            
            


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

        theme default

        styles {
            element "Web Front-End" {
                shape WebBrowser
            }
            element "Database" {
                shape Cylinder
            }
        }
    }
}

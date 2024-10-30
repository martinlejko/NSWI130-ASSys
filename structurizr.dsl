workspace "ENR System Workspace" "This workspace documents the architecture of the Enrollment (ENR) system." {

    model {
        enr_system = softwareSystem "Enrollments (ENR)" "Handles student enrollments and communications." {
            webApp = container "Web Application" "Interface for stakeholders to access ENR functionalities" "Web Front-End" {
                userInterface = component "User Interface" "Provides interface for user interactions"
            }

            group "Controllers" {
                studentController = container "Student Controller" "Handles requests related to student profiles"
                teacherController = container "Teacher Controller" "Handles requests related to teacher interactions"
                departmentController = container "Department Controller" "Handles requests related to department tasks"
                reportController = container "Report Controller" "Handles requests for generating statistical reports"
            }
            
            group "Managers" {
                enrollment_manager = container "Enrollment Manager" "Processes enrollment requests and interactions with the database" {
                    prerequisitesValidator = component "Prerequisites Validator" "Validates prerequisites of the students wanting to enroll in a course"
                }
                
                statistics_manager = container "Statistics Manager" "Generates and works with course statistics" {
                    reportGenerator = component "Report Generator" "Creates statistical reports for analysis and audits"
                }
                
                notification_manager = container "Notification Manager" "Notifies students enrolled in courses"
            }
            
            group "Repositories" {
                enrollmentRepository = container "Enrollment Repository" "Stores and retrieves enrollment data"
                reportRepository = container "Report Repository" "Stores report configurations and results"
            }
            
            group "Persistence Layer" {
                enrollment_database = container "Enrollment Database" "Stores information about courses and enrollments" "SQL" "Database" {
                    enrollmentTable = component "Enrollment Table" "Stores data on enrolled students and their course information"
                    courseTable = component "Course Table" "Stores information about available courses"
                    studentTable = component "Student Table" "Stores personal details and academic information for students"
                }
                
                log_database = container "Statistics Log Database" "Stores statistics of courses based on historical data" "SQL" "Database" {
                    statisticsTable = component "Course Statistics Table" "Stores statistics of courses"
                }
            }

            userInterface -> studentController "Submits student-related requests to"
            userInterface -> teacherController "Submits teacher-related requests to"
            userInterface -> departmentController "Submits department-related requests to"
            userInterface -> reportController "Requests reports from"

            studentController -> enrollment_manager "Forwards student enroll requests to"
            teacherController -> enrollment_manager "Forwards teacher enroll requests to"
            departmentController -> enrollment_manager "Forwards department requests to"
            reportController -> statistics_manager "Requests reports from"
            
            studentController -> enrollment_manager "Uses for enrollment logic"
            teacherController -> enrollment_manager "Uses for enrollment operations"
            departmentController -> enrollment_manager "Uses for enrollment operations"
            teacherController -> notification_manager "Uses for notifications to students"
            departmentController -> notification_manager "Uses for notifications to students"
            reportController -> statistics_manager "Uses for report generation"

            enrollmentRepository -> enrollment_database "Reads from and writes to"
            reportRepository -> log_database "Communicates with"

            notification_manager -> enrollmentRepository "Gets enrolled student information"
            enrollment_manager -> enrollmentRepository "Reads and writes enrollment data"
            statistics_manager -> enrollmentRepository "Reads from"
            statistics_manager -> reportRepository "Writes to"
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

        component enrollment_manager "enrollment_manager_component_diagram" {
            include *
        }

        component statistics_manager "statistics_manager_component_diagram" {
            include *
        }

        component notification_manager "notification_manager_component_diagram" {
            include *
        }

        component webApp "webApp_component_diagram" {
            include *
        }

        component studentController "studentController_component_diagram" {
            include *
        }

        component teacherController "teacherController_component_diagram" {
            include *
        }

        component departmentController "departmentController_component_diagram" {
            include *
        }

        component reportController "reportController_component_diagram" {
            include *
        }

        component enrollmentRepository "enrollmentRepository_component_diagram" {
            include *
        }

        component reportRepository "reportRepository_component_diagram" {
            include *
        }

        component enrollment_database "enrollment_database_component_diagram" {
            include *
        }

        component log_database "log_database_component_diagram" {
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

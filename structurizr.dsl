workspace "ENR System Workspace" "This workspace documents the architecture of the Enrollment (ENR) system for student management." {

    model {
        # Software systems
        enr_system = softwareSystem "Enrollments (ENR)" "Handles student enrollments and communications." {

            # ENR front-end containers
            webApp = container "Web Application" "Interface for stakeholders to access ENR functionalities." "React, HTML, CSS" "Web Front-End" {
                
                # Presentation Layer
                group "Presentation Layer" {
                    userInterface = component "User Interface" "Provides HTML and React UI for user interactions"
                }
                
                # Controller Layer
                group "Controller Layer" {
                    studentController = component "Student Controller" "Handles requests related to student profiles"
                    teacherController = component "Teacher Controller" "Handles requests related to teacher interactions"
                    departmentController = component "Department Controller" "Handles requests related to department tasks"
                    reportController = component "Report Controller" "Handles requests for generating statistical reports"
                }
                
                # Business Logic Layer
                group "Business Logic Layer" {
                    enrollmentService = component "Enrollment Service" "Manages student enrollment processes and updates"
                    studentService = component "Student Service" "Manages student profile data and verification"
                    reportingService = component "Reporting Service" "Generates reports based on enrollment data"
                }

                # Persistence Layer
                group "Persistence Layer" {
                    studentRepository = component "Student Repository" "Stores and retrieves student data"
                    enrollmentRepository = component "Enrollment Repository" "Stores and retrieves enrollment data"
                    reportRepository = component "Report Repository" "Stores report configurations and results"
                }

                # Relationships within webApp container
                userInterface -> studentController "Submits student-related requests to"
                userInterface -> teacherController "Submits teacher-related requests to"
                userInterface -> departmentController "Submits department-related requests to"
                userInterface -> reportController "Requests reports from"

                studentController -> studentService "Uses for business logic"
                teacherController -> enrollmentService "Uses for enrollment operations"
                departmentController -> enrollmentService "Uses for enrollment operations"
                reportController -> reportingService "Uses for report generation"

                studentService -> studentRepository "Reads from and writes to student data"
                enrollmentService -> enrollmentRepository "Reads from and writes to enrollment data"
                enrollmentService -> studentRepository "Accesses student data for enrollments"
                reportingService -> studentRepository "Reads student data for reports"
                reportingService -> enrollmentRepository "Reads enrollment data for reports"
                reportingService -> reportRepository "Accesses report data"
            }

            # Backend API container
            api = container "API Backend" "Handles business logic and communicates with the database." "Node.js, Express" {
                enrollmentManager = component "Enrollment Manager" "Processes enrollment requests and interactions with the database"
                reportGenerator = component "Report Generator" "Creates statistical reports for analysis and audits"

                # Relationships within api container
                enrollmentManager -> reportGenerator "Uses for generating reports"
            }

            # Database container with tables
            database = container "Enrollment Database" "Stores information about students, enrollments, and statistical data." "PostgreSQL" "Database" {
                studentTable = component "Student Table" "Stores personal details and academic information for students"
                enrollmentTable = component "Enrollment Table" "Stores data on enrolled students and their course information"
                courseTable = component "Course Table" "Stores information about available courses"
                departmentTable = component "Department Table" "Stores department details relevant to courses and students"
                reportTable = component "Report Table" "Stores generated reports and statistical information"

                # Relationships within database container
                enrollmentTable -> studentTable "References for student enrollments"
                enrollmentTable -> courseTable "References course information"
                courseTable -> departmentTable "Associated with department"
                reportTable -> studentTable "Uses student data for reports"
                reportTable -> enrollmentTable "Uses enrollment data for reports"
                reportTable -> courseTable "Uses course data for reports"
            }

            # Relationships within ENR system
            webApp -> api "Sends requests to"
            api -> database "Reads from and writes to"
        }

        # Actors
        student = person "Student" "Enrolled in courses and communicates with study department."
        teacher = person "Teacher" "Enters student enrollments and views reports."
        study_department_officer = person "Study Department Officer" "Manages student records and verifies enrollments."
        manager = person "Manager" "Oversees enrollments and generates statistical reports."

        # External Systems
        externalRecordsSystem = softwareSystem "External Records System" "Provides external student records." "Existing System"

        # Relationships
        student -> webApp "Accesses for enrollment and information"
        teacher -> webApp "Accesses for managing student enrollments"
        study_department_officer -> webApp "Accesses for record verification"
        manager -> api "Generates reports through API"
        api -> externalRecordsSystem "Makes API calls to for external records"

        # Define deployment environment
        deploymentEnvironment "Live" {
            deploymentNode "User's web browser" "Browsers used by students and teachers." "Web Front-End" {
                webAppInstance = containerInstance webApp
            }
            deploymentNode "Application Server" "Server hosting backend API" "Ubuntu 20.04" {
                apiInstance = containerInstance api
            }
            deploymentNode "Database Server" "Database hosting student and enrollment data" "Ubuntu 20.04" {
                databaseInstance = containerInstance database
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

        component api "api_component_diagram" {
            include *
            exclude "api -> externalRecordsSystem"
        }

        component webApp "webApp_component_diagram" {
            include *
        }
        
        component database "database_component_diagram" {
            include *
        }

        deployment enr_system "Live" "live_deployment" {
            include *
        }

        theme default

        styles {
            element "Existing System" {
                background #999999
                color #ffffff
            }
            element "Web Front-End" {
                shape WebBrowser
            }
            element "Database" {
                shape Cylinder
            }
        }
    }
}
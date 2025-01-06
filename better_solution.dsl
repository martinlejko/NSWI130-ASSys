workspace "WED_SCHED2 Workspace" "This workspace documents the architecture of the WED_SCHED2 team" {
    
    model {
        # software systems
        SIS_schedules = softwareSystem "SIS schedules" "System for creating, viewing, and management of MFF schedules." {

        dashboard = container "Schedules Dashboard" "Web user interface for students/teachers/management." "" "Web Front-End" {
                group "Presentation Layer"  {
                    scheduleChangesUI = component "UI for making changes in schedules."
                    scheduleViewUI = component "UI for viewing schedules"
                    schedulingPreferencesUI = component "UI for entering scheduling preferences" 
                    coursesUI = component "UI for viewing and changing information about courses"
                }
            }
        
        commitee_dashboard = container "Commitee Dashboard" "Web user interface for the scheduling commitee " "" "Web Front-End" {
                group "Presentation Layer"  {
                    schedulingUI = component "User Interface for the scheduling commitee"
                }
            }
            
        
        schedulingAlg = container "Scheduling algorithm" "Accepts data about courses to be scheduled and outputs a preliminary schedule to be rewieved and changed by the scheduling committee."  {
                group "Business Layer"  {
                    algorithm = component "Algorithm"
                }
                group "Persistence layer"  {
                    inputConversion = component "IO converter" "Converts data from the database into suitable input for the algorithm and vice versa."
                }
            }
           
        backend = container "Schedules Backend" "Processes user requests to view schedules and make changes"  {
                group "Business Layer"  {
                    api_gateway = component "API gateway"
                    scheduleViewer = component "Viewer" "Logic for viewing schedules"
                    coursesManager = component "Courses" "Logic for viewing and changing information about courses"
                    schedulingModule = component "Scheduling" "Logic for viewing and making changes in preliminary schedules"
                    scheduleChangesManager = component "Changes" "Logic for making changes in schedule"
                    schedulingPreferencesManager = component "Preferences" "Logic for entering scheduling preferences."
                    pers_layer = component "Persistence layer"
                }
            }
        database = container "Database" "" "" "Database" 
        alg_database = container "Algorithm cache" "" "" "Database"
            
        # relationships between containers
        dashboard -> backend "Makes API calls to"
        commitee_dashboard -> backend "Makes API calls to"
        backend -> database "Loads/Stores data"    
        backend -> schedulingAlg "Sends request to generate a preliminary schedule"    
        schedulingAlg -> alg_database "Caches created schedules"
        
        # relationships between components
        scheduleChangesUI -> api_gateway
        scheduleViewUI -> api_gateway
        schedulingUI -> api_gateway
        schedulingPreferencesUI -> api_gateway
        coursesUI -> api_gateway
        
        api_gateway -> scheduleViewer
        api_gateway -> coursesManager
        api_gateway -> schedulingModule
        api_gateway -> scheduleChangesManager
        api_gateway -> schedulingPreferencesManager
    
        
        scheduleViewer -> pers_layer
        coursesManager -> pers_layer
        schedulingModule -> pers_layer
        scheduleChangesManager -> pers_layer
        schedulingPreferencesManager -> pers_layer
        
        pers_layer -> database
        
        inputConversion -> algorithm 
        algorithm -> inputConversion
        schedulingModule -> algorithm "Sends request to generate a preliminary schedule"
        inputConversion -> database "Loads/Stores data"
        inputConversion -> alg_database "Loads/Stores data"
       
}
        # actors
        student = person "Student" 
        teacher = person "Teacher" "Views their schedule, can cancel/move lectures/practicals if necessary."
        commitee = person "Scheduling commitee" "Use the system to schedule courses for the next semester."
        management = person "Management officer" "Can make global changes in schedule, e.g. sports day, or other arbitrary changes."

        # relationships between users and the system
        student -> SIS_schedules "Views their schedule, enters scheduling preferences."
        teacher -> SIS_schedules "Views schedules, enters changes in their personal schedule."
        commitee -> SIS_schedules "Generate preliminary schedules using the scheduling algorithm, view and change these schedules."
        management -> SIS_schedules "View schedules, enter arbitrary changes in schedule."
    
        student -> dashboard "Views their schedule, enters scheduling preferences."
        teacher -> dashboard "Views schedules, enters changes in their personal schedule."
        commitee -> commitee_dashboard "Generate preliminary schedules using the scheduling algorithm, view and change these schedules."
        management -> dashboard "View schedules, enter arbitrary changes in schedule."
        
        
        production = deploymentEnvironment "Production" {
            deploymentNode "Load Balancer" {
        deploymentNode "User computer 1" {
            containerInstance dashboard
        }
        deploymentNode "User computer 2" {
            containerInstance dashboard
        }
        deploymentNode "User computer 3" {
            containerInstance dashboard
        }
    }

            deploymentNode "Commitee computer" {
                containerInstance commitee_dashboard
            }
            deploymentNode "Backend server" {
                containerInstance backend
            }
            deploymentNode "Algorithm server" {
                containerInstance schedulingAlg
                containerInstance alg_database
            }
            deploymentNode "Database server" {
                containerInstance database
            }

        }
                
        development = deploymentEnvironment "Development - Backend" {
            deploymentNode "Developer Machine" {
                containerInstance backend
                containerInstance database
            }
/*             deploymentNode "Backend server" {
                containerInstance backend
            }
            deploymentNode "Database server" {
                containerInstance database
            } */

        }
    }
    
    
    views {
        deployment * production {
            include *
            autoLayout lr
        }

        deployment * development {
            include *
            autoLayout lr
        }

        systemContext SIS_schedules "SISSchedulesSystemContextDiagram" {
            include *
        }
        container SIS_schedules "SISSchedulesContainerDiagram" {
            include *
        }
        component dashboard "dashboardComponentDiagram" {
            include *
        }
        component backend "backendComponentDiagram" {
            include *
        }
        component schedulingAlg "schedulingAlgComponentDiagram" {
            include *
        }
        
        dynamic backend {
            title "View schedule by student/teacher"
            student -> dashboard "Clicks button"
            dashboard -> api_gateway "Submits request to"
            api_gateway -> scheduleViewer "Submits request to"
            scheduleViewer -> pers_layer "Submits request to"
            pers_layer -> database "Submits request to"
            database -> pers_layer "Returns data"
            pers_layer -> scheduleViewer "Returns data"
            scheduleViewer -> api_gateway "Returns request"
            api_gateway -> dashboard "Returns request"
            dashboard -> student "Shows schedule"
        }
        dynamic backend {
            title "Make changes in schedule during the semester"
            management -> dashboard "Clicks button"
            dashboard -> api_gateway "Submits request to"
            api_gateway -> scheduleChangesManager "Submits request to"
            scheduleChangesManager -> pers_layer "Submits request to"
            pers_layer -> database "Submits request to"
            database -> pers_layer "Returns data"
            pers_layer -> scheduleChangesManager "Returns data"
            scheduleChangesManager -> api_gateway "Returns request"
            api_gateway -> dashboard "Returns request"
            dashboard -> management "Shows changes"
        }
        dynamic backend {
            title "Enter scheduling preferences"
            teacher -> dashboard "Clicks button"
            dashboard -> api_gateway "Submits request to"
            api_gateway -> schedulingPreferencesManager "Submits request to"
            schedulingPreferencesManager -> pers_layer "Submits request to"
            pers_layer -> database "Submits request to"
            database -> pers_layer "Returns data"
            pers_layer -> schedulingPreferencesManager "Returns data"
            schedulingPreferencesManager -> api_gateway "Returns request"
            api_gateway -> dashboard "Returns request"
            dashboard -> teacher "Shows entered preferences"
        }
        dynamic backend {
            title "Generating a schedule"
            commitee -> commitee_dashboard "Clicks button"
            commitee_dashboard -> api_gateway "Submits request to"
            api_gateway -> schedulingModule "Submits request to"
            schedulingModule -> schedulingAlg "Submits request for a new schedule"
            schedulingAlg -> database "Submits request for data"
            database -> schedulingAlg "Returns data"
            schedulingAlg -> schedulingModule "Returns new schedule"
            schedulingModule -> api_gateway "Returns new schedule"
            api_gateway -> commitee_dashboard "Returns new schedule"
            commitee_dashboard -> commitee "Shows new schedule"
            
        }
        dynamic backend {
            title "Make changes in new schedule"
            commitee -> commitee_dashboard "Clicks button"
            commitee_dashboard -> api_gateway "Submits a change"
            api_gateway -> schedulingModule "Submits a change"
            schedulingModule -> pers_layer "Submits a change"
            pers_layer -> database "Submits a change"
            database -> pers_layer "Returns changed data"
            pers_layer -> schedulingModule "Returns changed data"
            schedulingModule -> api_gateway "Returns request"
            api_gateway -> commitee_dashboard "Returns request"
            commitee_dashboard -> commitee "Shows changes"
        }
        dynamic backend {
            title "View and change information about courses"
            management -> dashboard "Clicks button"
            dashboard -> api_gateway "Submits request to"
            api_gateway -> coursesManager "Submits request to"
            coursesManager -> pers_layer "Submits request to"
            pers_layer -> database "Submits request to"
            database -> pers_layer "Returns data"
            pers_layer -> coursesManager "Returns data"
            coursesManager -> api_gateway "Returns request"
            api_gateway -> dashboard "Returns request"
            dashboard -> management "Shows changes"
        }
        
        
        
        styles {
            element "Existing System" {
                background #999999
                color #ffffff
            }

            element "Web Front-End"  {
                shape WebBrowser
            }

            element "Database"  {
                shape Cylinder
            }
        }
    }
}  

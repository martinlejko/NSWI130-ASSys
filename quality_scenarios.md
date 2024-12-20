# Scenarios

## Scalability Scenario

#### **Source:**  
**System**

#### **Stimulus:**  
A large number of users access the system simultaneously during peak times, such as the release of new schedules or significant updates. The system operates on a single server, leading to performance bottlenecks and slower response times.

#### **Artifact (Environment):**  
**Scheduling System Backend**

#### **Response:**  
Integrate a **Load Balancer** to distribute incoming requests evenly across multiple instances of the backend. If multiple servers are not available, the Load Balancer ensures that the single server processes requests sequentially and efficiently, reducing the likelihood of crashes or overload.

#### **Measure:**  
The system maintains:  
- An **average response time** of less than **2 seconds** for all users, even during peak traffic.  
- The ability to handle **200% of the typical request volume** without failures.

----

## Scalability Scenario 2

#### **Source:**  
**System**

#### **Stimulus:**  
A large number of users access the system simultaneously during peak times, such as the release of new schedules or significant updates. The synchronous architecture of the system leads to performance bottlenecks and slower response times as requests are processed sequentially.

#### **Artifact (Environment):**  
**Scheduling System Backend**

#### **Response:**  
Redesign the backend architecture to be **asynchronous**. By leveraging asynchronous processing and non-blocking I/O operations, the system can handle multiple requests concurrently. Tasks such as database queries and external API calls are decoupled, ensuring that the system efficiently utilizes server resources without being blocked by slower operations.

#### **Measure:**  
The system maintains:  
- An **average response time** of less than **2 seconds** for all users, even during peak traffic.  
- The ability to handle **300% of the typical request volume** without failures or degradation in performance.

----

## Modifiability scenario 1

#### **Source:**   
Developer

#### **Stimulus:** 
New requirements arise to enable bulk updates for course schedules. The current system design does not support adding new features without impacting existing components.

#### **Artifact (Environment):**
Scheduling System Backend – Courses Component

#### **Response:**  
Add a Bulk Update Component to the Courses logic, ensuring clear separation of concerns. This new component will handle bulk update requests while existing functionality remains unchanged.

#### **Measure:** 
New bulk update functionality is added with no regression issues in existing features.
Development time for future updates is reduced by 20% due to modular design.

----

## Runtime 1

#### **Source:**   
Scheduling System Backend

#### **Stimulus:** 
During the generation of schedules, repeated algorithm requests cause high latency because the system recalculates results unnecessarily. This happens when the same input data is processed multiple times.

#### **Artifact (Environment):** 
Scheduling System Backend – Algorithm Cache

#### **Response:** 
Implement a Caching Strategy to store and reuse generated schedules for identical input requests. The system checks the cache before running the scheduling algorithm.

#### **Measure:** 
Reduce algorithm computation time by 50% for duplicate or recurring schedule generation requests.
Cache hit ratio achieves at least 80% during peak load.

----

## Testability Scenario: 

#### **Source:**
Developer/QA Engineer

#### **Stimulus:**
A developer updates the scheduling algorithm to include a new rule that considers additional student preferences, requiring verification of its correctness.

#### **Artifact (Environment):**
Scheduling Algorithm Component

#### **Response:**
Develop a set of benchmark test cases with expected outcomes, including simple, complex, and edge cases.
Implement a simulation framework to feed synthetic datasets into the scheduling algorithm.
Compare generated schedules against expected outcomes using automated validation scripts.

#### **Measure:**
95% of test cases pass without manual intervention.
Errors identified within 10 minutes of running the automated tests.
The scheduling algorithm’s output matches expected results for all predefined edge cases.

----

## Security Scenario 1

#### **Source:**
Internal Misuse

#### **Stimulus:**
A teacher or management officer attempts unauthorized modifications to course or schedule data.

#### **Artifact (Environment):**
Scheduling Backend (Normal operation conditions)

#### **Response:**
Log all actions in the system with detailed metadata (e.g., user ID, timestamp, and action performed).
Allow admins to review audit logs and revoke access immediately in case of misuse.
Set granular permissions to ensure each user can only access and modify relevant data.

#### **Measure:**
100% of unauthorized actions flagged and logged.
The system passes an external security audit for role-based access control.
All critical actions include a confirmation prompt to prevent accidental misuse.

---

## Modifiability Scenario - Design-time (Daniel Lopata) 

#### **Source:**  
**Schedules Backend**  

#### **Stimulus:**  
A new version of the scheduling algorithm needs to be integrated, requiring changes to the API communication. Unclear boundaries between components cause chain effects when modifications are made.  

#### **Artifact (Environment):**  
**Scheduling Backend (Normal operation conditions)**  

#### **Response:**  
The API Gateway integrates the updated scheduling algorithm without requiring changes to unrelated components. Versioned APIs and abstraction layers ensure smooth integration.  

#### **Measure:**  
The updated algorithm is integrated and tested with **no more than 3 person-days of effort**.  

---

## Security Scenario - Run-time (Daniel Lopata)

#### **Source:**  
**Schedules Backend**  

#### **Stimulus:**  
An unauthorized user attempts to access or manipulate scheduling data through API endpoints. The system does not currently have sufficient access controls in place to restrict such attempts.  

#### **Artifact (Environment):**  
**Scheduling Backend (Normal operation conditions)**  

#### **Response:**  
Implement **role-based access control** and secure API endpoints with authentication tokens. Only authorized users with the correct permissions can access or modify scheduling data. Unauthorized access attempts are logged and flagged for review.  

#### **Measure:**  
- 100% of unauthorized requests are denied access.  
- All access attempts are logged with response times under **2 seconds**.  
- Security audit logs are available for review.

----

## Modifiability - Design-time 

### **New Frontend for Mobile Application** (David Petera)

#### **Source:**
**Developer**

#### **Stimulus**
We want to increase the ease of use of SIS by allowing users to interact with the scheduling process or view the schedule and other information on their phones.

#### **Artifact (Environment):** 
**Frontend, New Mobile Frontend Container**

#### **Response:**  
Add new Mobile Frontend Container. We do not have to modify the backend because the API is already sufficient.

#### **Measure:**
It should be possible to develop the new frontend independently and relatively fast.

----

## Availability - Run-time 

### **Database not Responding** (David Petera)

#### **Source:**
**Schedules Backend Container**

#### **Stimulus**
Unable to load data from Database.

#### **Artifact (Environment):** 
**Database, Normal load Operation**

#### **Response:**  
Repeat and possibly Log.

#### **Measure:**
2s of Downtime

## Performance Scenario (Samuel Koribanic)

#### **Source:**  
**System**  

#### **Stimulus:**  
The scheduling algorithm takes too long to process schedules for large institutions with thousands of courses and students, leading to unacceptable delays during schedule generation.  

#### **Artifact (Environment):**  
**Scheduling Algorithm Backend**  

#### **Response:**  
Refactor the scheduling algorithm to use **parallel processing** and divide large scheduling tasks into smaller, independent sub-tasks that can run concurrently. Utilize a distributed computing framework to execute the tasks across multiple servers or cores.  

#### **Measure:**  
- Schedule generation time is reduced by **70%** for datasets with more than 10,000 entries.  
- The system processes at least **5,000 concurrent scheduling requests** without degradation in performance.  

---

## Usability Scenario (Samuel Koribanic)

#### **Source:**  
**End User (Student/Teacher)**  

#### **Stimulus:**  
Users struggle to navigate the scheduling interface, reporting confusion when attempting to perform basic tasks such as viewing or modifying their schedules.  

#### **Artifact (Environment):**  
**Scheduling System Frontend**  

#### **Response:**  
Redesign the user interface to follow **intuitive design principles** and conduct usability testing with diverse user groups. Implement clear instructions, tooltips, and error messages. Add a guided onboarding process for first-time users to familiarize them with key features.  

#### **Measure:**  
- **90% of users** complete key tasks (e.g., viewing a schedule, updating preferences) without external assistance.  
- Average task completion time is reduced by **30%**.  
- User satisfaction score increases to at least **4.5 out of 5** in post-task surveys.  


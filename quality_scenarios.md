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


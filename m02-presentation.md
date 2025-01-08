# Quality Scenarios

Team: Samuel Koribanič, Daniel Lopata, David Petera, Martin Lejko, Matúš Klečka, Adam Budai

## Scalability Scenario (Martin Lejko)

#### **Source:**  
Users

#### **Stimulus:**  
A large number of users access the system simultaneously during peak times, such as the release of new schedules or significant updates. The system operates on a single server, leading to performance bottlenecks and slower response times.

#### **Artifact (Environment):**  
Scheduling System Backend

#### **Response:**  
When the scheduling system operates correctly, it efficiently handles a large number of simultaneous users, ensuring that requests are processed in a timely manner. Even during peak traffic times, or big waves of users such as the release of new schedules or updates. This ideal scenario allows all users to access the system without delays or interruptions.

However, the current implementation struggles to handle peak traffic due to performance bottlenecks caused by operating on a single server. During these times, response times increase, and the likelihood of server overload or failure rises.

#### **Measure:**  
The system maintains:  
- An **average response time** of less than **2 seconds** for all users, even during peak traffic.  
- The ability to handle **200% of the typical request volume** without failures.

### **Solution:**
To address this limitation, the system needs to integrate both a Load Balancer and additional web servers. The Load Balancer would distribute incoming traffic evenly across multiple servers. Enabling the system to process requests in parallel. This architecture would prevent any single server from being overwhelmed.

----

## Scalability Scenario 2 (Matúš Klečka)

#### **Source:**  
Users

#### **Stimulus:**  
A large number of users access the system simultaneously during peak times, such as the release of new schedules or significant updates. The synchronous architecture of the system leads to performance bottlenecks and slower response times as requests are processed sequentially.

#### **Artifact (Environment):**  
Scheduling System Backend

#### **Response:** 
When the scheduling system operates correctly, it efficiently handles a large number of simultaneous users, ensuring that requests are processed in a timely manner. Even during peak traffic times, or big waves of users such as the release of new schedules or updates. With an asynchronous architecture, the system processes multiple requests simultaneously, ensuring that database queries, external API calls, and other tasks do not block the main workflow.

However, the current implementation relies on a synchronous architecture, which processes requests sequentially. This design leads to performance bottlenecks

#### **Measure:**  
The system maintains:  
- An **average response time** of less than **2 seconds** for all users, even during peak traffic.  
- The ability to handle **300% of the typical request volume** without failures or degradation in performance.

### **Solution:**
To address this issue, the backend architecture should be redesigned to adopt asynchronous processing. By leveraging non-blocking I/O operations, the system can handle multiple requests concurrently.
This redesign would enable the system to maximize resource utilization and handle higher traffic loads.

----

## Testability Scenario (Adam Budai)

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
Errors identified within 3 minutes of running the automated tests.
The scheduling algorithm’s output matches expected results for all predefined edge cases.

---

## Security Scenario - Run-time (Daniel Lopata)

#### **Source:**  
**Schedules Backend**  

#### **Stimulus:**  
An unauthorized user attempts to access or manipulate scheduling data through API endpoints.

#### **Artifact (Environment):**  
**Scheduling Backend (Normal operation conditions)**  

#### **Response:**  
Implement **role-based access control** and secure API endpoints with authentication tokens. Only authorized users with the correct permissions can access or modify scheduling data. Unauthorized access attempts are logged and flagged for review.  

#### **Measure:**  
- 100% of unauthorized requests are denied access.  
- All access attempts are logged with response times under **2 seconds**.  

----


## Modifiability - Design-time (David Petera)

**New Frontend for Mobile Application** 

#### **Source:**
**Users**

#### **Stimulus**
Users want to increase the ease of use of SIS scheduling process or viewing the schedule and other information on their phones.

#### **Artifact (Environment):** 
**Frontend**

#### **Response:**  
New mobile frontend is implemented.

#### **Measure:**
It should be possible to develop the new frontend with minimal backend changes and within 4 man-months of development and testing.

----

## Modifiability Scenario - Design-time (Samuel Koribanic) 

#### **Source:**  
Developers 

#### **Stimulus:**  
A new version of the scheduling algorithm needs to be integrated, requiring changes to the API communication. Unclear boundaries between components cause chain effects when modifications are made.  

#### **Artifact (Environment):**  
**Scheduling Backend (Normal operation conditions)**  

#### **Response:**  
The API Gateway integrates the updated scheduling algorithm without requiring changes to unrelated components. Versioned APIs and abstraction layers ensure smooth integration.  

#### **Measure:**  
The updated algorithm is integrated and tested with **no more than 3 person-days of effort**.  

---

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
- An **average response time** of less than **3 seconds** for all users, even during peak traffic.  
- The ability to handle **200% of the typical request volume** without failures.

## Scalability Scenario 2

#### **Source:**  
**System**

#### **Stimulus:**  
A large number of users (teachers, students, and committee members) access the system simultaneously during peak times, such as the release of new schedules or significant updates. The synchronous architecture of the system leads to performance bottlenecks and slower response times as requests are processed sequentially.

#### **Artifact (Environment):**  
**Scheduling System Backend**

#### **Response:**  
Redesign the backend architecture to be **asynchronous**. By leveraging asynchronous processing and non-blocking I/O operations, the system can handle multiple requests concurrently. Tasks such as database queries and external API calls are decoupled, ensuring that the system efficiently utilizes server resources without being blocked by slower operations.

#### **Measure:**  
The system maintains:  
- An **average response time** of less than **2 seconds** for all users, even during peak traffic.  
- The ability to handle **300% of the typical request volume** without failures or degradation in performance.  

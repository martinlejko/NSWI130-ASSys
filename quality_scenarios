# Scalability Scenario

### **Source:**  
**System**

### **Stimulus:**  
A large number of users (teachers, students, and committee members) access the system simultaneously during peak times, such as the release of new schedules or significant updates. The system operates on a single server, leading to performance bottlenecks and slower response times.

### **Artifact (Environment):**  
**Scheduling System Backend**

### **Response:**  
Integrate a **Load Balancer** to distribute incoming requests evenly across multiple instances of the backend. If multiple servers are not available, the Load Balancer ensures that the single server processes requests sequentially and efficiently, reducing the likelihood of crashes or overload.

### **Measure:**  
The system maintains:  
- An **average response time** of less than **3 seconds** for all users, even during peak traffic.  
- The ability to handle **200% of the typical request volume** without failures.

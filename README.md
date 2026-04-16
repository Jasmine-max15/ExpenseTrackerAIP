# 🚀 Expenzo - Modern Expense Tracker

Welcome to **Expenzo**, a highly aesthetic and fully responsive Expense Tracker built using Java Servlets, JSP, and Tailwind CSS. 

We've recently completely overhauled this project to include a **stunning Dark-Mode Glassmorphism UI**, fully animated transitions, and interactive **Chart.js Analytics** straight into the dashboard!

---

## 💻 Tech Stack
- **Backend:** Java (Servlets 6.0, JDBC) 
- **Frontend:** JSP, HTML, Tailwind CSS, FontAwesome Icons, Chart.js
- **Database:** MySQL 
- **Server Required:** Apache Tomcat (v10.1 or higher)
- **Java Version:** Java 11, 17, or 21+

---

## 🛠️ How to Run This on Your System (Simple Steps)

### Step 1: Set up the Database 🗄️
1. Make sure you have **MySQL** installed on your computer.
2. Open your MySQL client (Workbench or Terminal).
3. Open the `database/schema.sql` file provided in this project. Copy all the SQL commands and run them. This will automatically create the `expense_tracker` database and build the necessary tables.

### Step 2: Configure the Database Connection 🔌
1. Open the file `src/com/tracker/util/DatabaseConnection.java`.
2. Find the database credentials around **line 20**.
3. Change the `USER` and `PASSWORD` strings if your local MySQL database has a different username or password *(e.g., if you don't have a password on root, just leave it as `""`)*.

*(Magic Feature: If the app completely fails to connect to MySQL, it has a built-in fallback sequence to automatically run off an embedded temporary H2 Database so the app won't crash!)*

### Step 3: Run the Application 🚀

**Method A: Using an IDE (Eclipse/IntelliJ)**
1. Import this project folder into your IDE as a **Dynamic Web Project**.
2. Right-click the project folder -> `Run As` -> `Run on Server`.
3. Select your Apache Tomcat 10.1+ server.
4. The IDE will build and launch it instantly at `http://localhost:8080/ExpenseTracker`.

**Method B: Using Visual Studio Code (VS Code)**
1. Install the **"Extension Pack for Java"** and **"Community Server Connectors"** (or **"Tomcat for Java"**) extensions in VS Code.
2. In the bottom-left of VS Code, find the "Tomcat Servers" or "Servers" panel and click `+` to add your local Tomcat installation directory.
3. Right-click the server, select **Run War Package** (or **Add Deployment**), and choose either the `ExpenseTracker.war` file or the `WebContent` folder.
4. Right-click the server and click **Start**. The app will be running at `http://localhost:8080/ExpenseTracker`.

**Method C: Using the Build Script (Mac/Linux Users)**
1. Make sure Tomcat is running on your system.
2. Open your terminal in the project directory.
3. Run `./build.sh`. This script will automatically compile everything perfectly and deploy the website to your Tomcat server.
4. Open your browser and go to `http://localhost:8080/ExpenseTracker`.

---

## 🔥 What's New?
* **Live Analytic Charts**: Added dynamic Chart.js rendering to visualize category spending (Doughnut Chart) and spending trends (Bar Chart).
* **Modern Aesthetic**: Replaced basic CSS with Tailwind CSS for high-quality responsive glassmorphism features.
* **Bug Fixes**: Removed UI bugs and solved Java compiler version mismatch errors. 

Enjoy tracking your expenses! 💸

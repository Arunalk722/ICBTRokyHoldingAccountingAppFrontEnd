# Roky Holding - Software Engineering BSC Topup Development Project
## System Guide Report

### Executive Summary
This comprehensive system guide provides detailed information about the Roky Holding application, including setup instructions, user workflows, technical specifications, and improvement recommendations. The system is designed for construction and project-based businesses with comprehensive project management and financial control capabilities.

---

## 1. System Overview

### 1.1 Application Purpose
The Roky Holding application is a comprehensive business management system designed for:
- **Project Management**: Construction project lifecycle management
- **Financial Control**: Payment processing and budget management
- **Material Management**: Inventory tracking and cost control
- **User Management**: Role-based access control and permissions
- **Reporting**: Comprehensive analytics and reporting capabilities

### 1.2 Target Users
- **Project Managers**: Project planning and execution
- **Financial Officers**: Payment processing and budget control
- **Site Engineers**: Material management and cost tracking
- **Administrators**: System configuration and user management
- **Executives**: High-level reporting and decision support

### 1.3 System Capabilities
- **Multi-platform Support**: Android, iOS, and Web applications
- **Real-time Synchronization**: Live data updates across platforms
- **Offline Capability**: Basic functionality without internet connection
- **Multi-language Support**: Localization capabilities
- **Export Functions**: CSV and PDF report generation

---

## 2. System Setup and Installation

### 2.1 Development Environment Setup

#### 2.1.1 Prerequisites
```
Required Software:
- Flutter SDK (3.x or higher)
- Dart SDK (3.x or higher)
- PHP 8.x
- MySQL 8.0.29
- XAMPP/WAMP/MAMP
- Git
- IDE (VS Code, Android Studio, or similar)
```

#### 2.1.2 Backend Setup
```bash
# 1. Clone the repository
git clone [repository-url]
cd roky-app

# 2. Configure web server
# Copy api/ folder to web server directory (e.g., htdocs/)

# 3. Database setup
mysql -u root -p < Dump20250825.sql

# 4. Configure database connection
# Edit api/src/cnfg/db_conn.php with database credentials

# 5. Install PHP dependencies
cd api/
composer install

# 6. Configure environment variables
# Create .env file with required configurations
```

#### 2.1.3 Frontend Setup
```bash
# 1. Navigate to client directory
cd client/

# 2. Install Flutter dependencies
flutter pub get

# 3. Configure API endpoints
# Edit env/api_info.dart with correct API URLs

# 4. Run the application
flutter run
```

### 2.2 Production Deployment

#### 2.2.1 Server Requirements
```
Minimum Server Specifications:
- CPU: 2 cores
- RAM: 4GB
- Storage: 50GB SSD
- OS: Ubuntu 20.04 LTS or CentOS 8
- Web Server: Apache 2.4 or Nginx 1.18
- PHP: 8.0+
- MySQL: 8.0+
```

#### 2.2.2 Deployment Steps
```bash
# 1. Server preparation
sudo apt update
sudo apt install apache2 php mysql-server

# 2. Application deployment
sudo cp -r api/ /var/www/html/
sudo chown -R www-data:www-data /var/www/html/api/

# 3. Database setup
sudo mysql -u root -p < Dump20250825.sql

# 4. SSL certificate installation
sudo certbot --apache

# 5. Firewall configuration
sudo ufw allow 80,443,22
```

---

## 3. User Interface Guide

### 3.1 Application Navigation

#### 3.1.1 Main Menu Structure
```
Home Dashboard
├── Module 1: Authentication
│   ├── Login/Logout
│   ├── Registration
│   └── Account Setup
├── Module 2: Home & Navigation
│   ├── Dashboard
│   ├── Permission Management
│   └── App Maintenance
├── Module 3: Project Management
│   ├── Project Management
│   ├── Location Management
│   ├── Material Management
│   └── Estimation Tools
├── Module 4: Financial Operations
│   ├── Payment Requests
│   ├── Bill Management
│   └── Budget Tracking
├── Module 5: Payment Processing
│   ├── Payment Approval
│   └── Payment Processing
├── Module 6: Reporting & Analytics
│   ├── Project Dashboards
│   ├── Financial Reports
│   └── IOU Management
└── Module 7: Notifications
    └── Reminders
```

#### 3.1.2 User Interface Elements
- **Material Design 3**: Modern, intuitive interface
- **Responsive Design**: Adapts to different screen sizes
- **Dark/Light Theme**: User preference support
- **Accessibility**: Screen reader and keyboard navigation support

### 3.2 Key User Workflows

#### 3.2.1 User Authentication
```
1. Launch Application
2. Enter Username and Password
3. System Validates Credentials
4. Token Generation and Storage
5. Redirect to Home Dashboard
6. Load User Permissions
```

#### 3.2.2 Project Creation
```
1. Navigate to Project Management
2. Click "Add New Project"
3. Fill Project Details:
   - Project Name
   - Client Information
   - Tender Details
   - Start/End Dates
   - Budget Information
4. Submit for Approval
5. Receive Confirmation
```

#### 3.2.3 Payment Request Process
```
1. Access Payment Request Module
2. Select Request Type (Office/Project)
3. Fill Request Details:
   - Amount
   - Purpose
   - Supporting Documents
4. Submit Request
5. Await Authorization
6. Track Request Status
7. Receive Payment Confirmation
```

---

## 4. Technical Specifications

### 4.1 Frontend Specifications

#### 4.1.1 Flutter Application
```dart
// Key Dependencies
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.2
  font_awesome_flutter: ^10.6.0
  url_launcher: ^6.2.1
```

#### 4.1.2 State Management
```dart
// Singleton Pattern for API Token
class APIToken {
  static final APIToken _instance = APIToken._privateConstructor();
  factory APIToken() => _instance;
  String? _token;
  set token(String? value) => _token = value;
  String? get token => _token;
}
```

#### 4.1.3 API Integration
```dart
// HTTP Request Example
Future<void> loginSystem() async {
  final response = await http.post(
    Uri.parse('${APIHost().apiURL}/login_controller.php/login'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "username": _userName.text,
      "password": _password.text
    }),
  );
}
```

### 4.2 Backend Specifications

#### 4.2.1 PHP Configuration
```php
// Database Connection
class Database {
    private $conn;
    public function __construct() {
        $config = require __DIR__ . '/db_conn.php';
        $dbConfig = $config['db'];
        $dsn = "{$dbConfig['driver']}:host={$dbConfig['host']};dbname={$dbConfig['database']}";
        $this->conn = new PDO($dsn, $dbConfig['username'], $dbConfig['password']);
    }
}
```

#### 4.2.2 API Endpoint Structure
```php
// Controller Pattern
if ($route === 'CreateProject' && $_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = file_get_contents("php://input");
    $result = ProjectsManagement::createProject($data);
    echo json_encode($result);
}
```

#### 4.2.3 Security Implementation
```php
// Token Validation
function validateToken(): void {
    $headers = getallheaders();
    $token = $headers['x-token'] ?? '';
    $decrypted = TextEncryptor::decrypt($token);
    if (empty($token) || !$decrypted) {
        echo json_encode(["message" => "Token expired or invalid", "status" => 401]);
        exit;
    }
}
```

### 4.3 Database Specifications

#### 4.3.1 Core Tables
```sql
-- User Management
CREATE TABLE tbl_users (
    idtbl_users INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(45) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    pwd VARCHAR(255),
    is_active TINYINT DEFAULT 1,
    is_advance_mode TINYINT DEFAULT 0,
    req_pw_change TINYINT DEFAULT 0
);

-- Project Management
CREATE TABLE tbl_projects (
    idtbl_projects INT PRIMARY KEY AUTO_INCREMENT,
    tender VARCHAR(45) NOT NULL,
    project_name VARCHAR(100) NOT NULL,
    client_name VARCHAR(100),
    tender_cost DECIMAL(20,2),
    start_date DATE,
    end_date DATE,
    is_active TINYINT DEFAULT 1
);
```

#### 4.3.2 Data Relationships
```sql
-- Foreign Key Relationships
ALTER TABLE tbl_payment_request 
ADD CONSTRAINT fk_payment_user 
FOREIGN KEY (created_by) REFERENCES tbl_users(idtbl_users);

ALTER TABLE tbl_materials 
ADD CONSTRAINT fk_material_project 
FOREIGN KEY (project_id) REFERENCES tbl_projects(idtbl_projects);
```

---

## 5. Security Implementation

### 5.1 Authentication System

#### 5.1.1 Token-based Authentication
```php
// Token Generation
class TextEncryptor {
    public static function encrypt($plainText) {
        $encryptData = [
            "jti" => bin2hex(random_bytes(16)),
            "fingerprint" => hash('sha256', $_SERVER['HTTP_USER_AGENT']),
            "author" => $plainText,
            "exp" => date("Y-m-d H:i:s", strtotime("+12 hour"))
        ];
        return base64_encode($encryptedText . '::' . base64_encode($iv) . '::' . $hmac);
    }
}
```

#### 5.1.2 Password Security
```php
// Password Hashing
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);
if (password_verify($password, $hashedPassword)) {
    // Login successful
}
```

### 5.2 Data Protection

#### 5.2.1 Input Validation
```php
// SQL Injection Prevention
$query = "SELECT * FROM tbl_users WHERE user_name = :user_name";
$params = [':user_name' => $username];
$stmt = $this->conn->prepare($query);
$stmt->execute($params);
```

#### 5.2.2 XSS Prevention
```php
// Output Sanitization
$sanitizedOutput = htmlspecialchars($userInput, ENT_QUOTES, 'UTF-8');
```

---

## 6. Performance Optimization

### 6.1 Database Optimization

#### 6.1.1 Indexing Strategy
```sql
-- Performance Indexes
CREATE INDEX idx_users_username ON tbl_users(user_name);
CREATE INDEX idx_projects_tender ON tbl_projects(tender);
CREATE INDEX idx_payment_created_date ON tbl_payment_request(created_date);
```

#### 6.1.2 Query Optimization
```sql
-- Optimized Queries
SELECT p.*, u.user_name 
FROM tbl_projects p 
INNER JOIN tbl_users u ON p.created_by = u.idtbl_users 
WHERE p.is_active = 1 
ORDER BY p.created_date DESC;
```

### 6.2 Frontend Optimization

#### 6.2.1 Image Optimization
```dart
// Compressed Image Upload
Future<File?> compressImage(File file) async {
  final compressedFile = await FlutterImageCompress.compressAndGetFile(
    file.path,
    file.path.replaceAll('.jpg', '_compressed.jpg'),
    quality: 70,
  );
  return compressedFile;
}
```

#### 6.2.2 Caching Strategy
```dart
// Local Data Caching
Future<void> cacheUserData(Map<String, dynamic> userData) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_data', jsonEncode(userData));
}
```

---

## 7. Testing Strategy

### 7.1 Manual Testing Procedures

#### 7.1.1 User Acceptance Testing
```
Test Scenarios:
1. User Registration and Login
2. Project Creation and Management
3. Payment Request Processing
4. Report Generation
5. Data Export Functions
6. Multi-user Collaboration
7. Offline Functionality
8. Cross-platform Compatibility
```

#### 7.1.2 Security Testing
```
Security Test Cases:
1. Authentication Bypass Attempts
2. SQL Injection Testing
3. XSS Vulnerability Testing
4. Token Validation Testing
5. Permission Escalation Testing
6. Session Management Testing
```

### 7.2 Automated Testing Recommendations

#### 7.2.1 Unit Testing
```dart
// Flutter Unit Tests
void main() {
  group('Login Tests', () {
    test('should validate user credentials', () {
      final loginService = LoginService();
      expect(loginService.validateCredentials('user', 'pass'), isTrue);
    });
  });
}
```

#### 7.2.2 Integration Testing
```php
// PHP Integration Tests
class ProjectControllerTest extends TestCase {
    public function testCreateProject() {
        $data = ['project_name' => 'Test Project', 'tender' => 'T001'];
        $result = ProjectsManagement::createProject(json_encode($data));
        $this->assertEquals(200, $result['status']);
    }
}
```

---

## 8. Monitoring and Maintenance

### 8.1 System Monitoring

#### 8.1.1 Application Logging
```php
// Event Logging
class EventLogger {
    public static function writeLog($data, $module, $action) {
        $logEntry = [
            'timestamp' => date('Y-m-d H:i:s'),
            'module' => $module,
            'action' => $action,
            'data' => $data,
            'user' => $_SESSION['user'] ?? 'system'
        ];
        // Store in database
    }
}
```

#### 8.1.2 Error Tracking
```php
// Exception Handling
try {
    // Business logic
} catch (Exception $e) {
    ExceptionLog::writeLog("Error: " . $e->getMessage(), 'ModuleName');
    return ['status' => 500, 'message' => 'Internal Server Error'];
}
```

### 8.2 Backup and Recovery

#### 8.2.1 Database Backup
```php
// Automated Backup
public function backupDatabase(): array {
    $filename = 'backup_' . date('Y-m-d_H-i-s') . '.sql';
    $command = sprintf(
        'mysqldump --user=%s --host=%s --port=%s %s > "%s"',
        $db['username'], $db['host'], $db['port'], $db['database'], $backupPath
    );
    exec($command);
}
```

#### 8.2.2 Recovery Procedures
```
Recovery Steps:
1. Stop application services
2. Restore database from backup
3. Verify data integrity
4. Restart application services
5. Test critical functionality
6. Notify users of system restoration
```

---

## 9. System Improvements and Recommendations

### 9.1 Immediate Improvements

#### 9.1.1 Code Quality Enhancements
```
Priority 1: Code Organization
- Implement proper MVC architecture
- Add comprehensive error handling
- Standardize API response formats
- Implement input validation middleware

Priority 2: Security Enhancements
- Implement OAuth 2.0 authentication
- Add API rate limiting
- Enhance password policies
- Implement audit logging
```

#### 9.1.2 Performance Optimizations
```
Database Optimizations:
- Implement query caching
- Add database connection pooling
- Optimize slow queries
- Implement read replicas

Frontend Optimizations:
- Implement lazy loading
- Add image compression
- Optimize API calls
- Implement offline caching
```

### 9.2 Long-term Improvements

#### 9.2.1 Architecture Evolution
```
Phase 1: Framework Migration
- Migrate to Laravel framework
- Implement proper ORM
- Add API documentation
- Implement testing framework

Phase 2: Microservices
- Decompose monolithic application
- Implement service discovery
- Add message queuing
- Implement distributed caching
```

#### 9.2.2 Technology Stack Upgrades
```
Modern Technologies:
- React Native for mobile app
- Node.js/Express for API
- PostgreSQL for database
- Redis for caching
- Docker for containerization
- Kubernetes for orchestration
```

### 9.3 Feature Enhancements

#### 9.3.1 User Experience Improvements
```
UI/UX Enhancements:
- Implement progressive web app (PWA)
- Add real-time notifications
- Implement drag-and-drop interfaces
- Add advanced search functionality
- Implement data visualization
```

#### 9.3.2 Business Intelligence
```
Analytics Features:
- Real-time dashboards
- Predictive analytics
- Cost forecasting
- Performance metrics
- Custom report builder
```

---

## 10. Troubleshooting Guide

### 10.1 Common Issues and Solutions

#### 10.1.1 Authentication Issues
```
Problem: Login fails with valid credentials
Solution:
1. Check database connection
2. Verify password hashing
3. Check token generation
4. Validate session storage

Problem: Token expiration errors
Solution:
1. Check system time synchronization
2. Verify token expiration settings
3. Implement token refresh mechanism
4. Clear browser cache
```

#### 10.1.2 Performance Issues
```
Problem: Slow page loading
Solution:
1. Check database query performance
2. Implement query caching
3. Optimize image sizes
4. Enable compression

Problem: API timeout errors
Solution:
1. Increase PHP execution time
2. Optimize database queries
3. Implement request queuing
4. Add load balancing
```

#### 10.1.3 Data Synchronization Issues
```
Problem: Data not syncing between devices
Solution:
1. Check network connectivity
2. Verify API endpoints
3. Implement conflict resolution
4. Add data validation
```

### 10.2 Debugging Tools

#### 10.2.1 Frontend Debugging
```dart
// Debug Logging
void debugLog(String message) {
  if (kDebugMode) {
    print('DEBUG: $message');
  }
}
```

#### 10.2.2 Backend Debugging
```php
// PHP Debug Logging
error_log("DEBUG: " . $message);
ExceptionLog::writeLog($message, 'debug');
```

---

## 11. Documentation and Training

### 11.1 User Documentation

#### 11.1.1 User Manual
- **Getting Started Guide**: First-time setup instructions
- **Feature Documentation**: Detailed feature explanations
- **Troubleshooting Guide**: Common issues and solutions
- **Video Tutorials**: Step-by-step visual guides

#### 11.1.2 Administrator Guide
- **System Administration**: Configuration and maintenance
- **User Management**: Role and permission management
- **Backup Procedures**: Data backup and recovery
- **Security Guidelines**: Security best practices

### 11.2 Technical Documentation

#### 11.2.1 API Documentation
```
API Endpoints:
- Authentication: /login_controller.php
- Projects: /project_controller.php
- Payments: /payment_controller.php
- Reports: /report_controller.php

Response Formats:
{
  "status": 200,
  "message": "Success",
  "data": {...}
}
```

#### 11.2.2 Database Documentation
```
Schema Documentation:
- Table relationships
- Field descriptions
- Index information
- Constraint details
```

---

## 12. Conclusion

The Roky Holding application provides a comprehensive solution for project management and financial control in construction businesses. The system demonstrates good architectural principles with clear separation of concerns and modular design.

### 12.1 System Strengths
- **Comprehensive Functionality**: Covers all major business processes
- **User-Friendly Interface**: Intuitive Flutter-based UI
- **Security Focus**: Robust authentication and authorization
- **Scalable Architecture**: Modular design for future growth

### 12.2 Areas for Enhancement
- **Code Quality**: Better framework structure and testing
- **Performance**: Caching and optimization strategies
- **Documentation**: Comprehensive API and technical documentation
- **Modern Technologies**: Adoption of current best practices

### 12.3 Implementation Roadmap
1. **Immediate**: Security and performance improvements
2. **Short-term**: Framework migration and testing
3. **Medium-term**: Feature enhancements and modernization
4. **Long-term**: Scalability and cloud deployment

### 12.4 Success Metrics
- **User Adoption**: 90% user acceptance rate
- **Performance**: <3 second page load times
- **Reliability**: 99.9% uptime
- **Security**: Zero security breaches
- **Efficiency**: 50% reduction in manual processes

---

**Based on Code Analysis**: August 2025  
**System Version**: 1.0.1  

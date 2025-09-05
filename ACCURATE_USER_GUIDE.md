# Roky Holding - Accurate User Guide
## Based on Actual System Functionality

### Executive Summary
This user guide is based on the actual codebase analysis and provides accurate instructions for the real functionality available in the Roky Holding application.

---

## Table of Contents
1. [System Overview](#1-system-overview)
2. [Authentication](#2-authentication)
3. [Home Dashboard](#3-home-dashboard)
4. [Available Modules](#4-available-modules)
5. [User Operations](#5-user-operations)
6. [Troubleshooting](#6-troubleshooting)

---

## 1. System Overview

### 1.1 Application Purpose
The Roky Holding application is a construction project management system that handles:
- **Project Management**: Create and manage construction projects
- **Financial Operations**: IOU requests, payment processing, and settlements
- **Material Management**: Material tracking and requests
- **Estimation**: Project cost estimation and approval workflows
- **Reporting**: Various project and financial reports

### 1.2 User Roles and Permissions
Based on the actual code, the system supports these permission-based roles:

```
Permission Keys:
├── alw_auth: Approve Project IOU
├── alw_ofz_auth: Approve Office IOU
├── alw_req_pay: Request Payments & Settlements
├── alw_pm: Project Management
├── alw_mm: Material Management
├── alw_ec: Estimation Creating
├── alw_rpt: Report Viewing
├── alw_prl: Personal IOU Requests
├── alw_ofz_exp: Office IOU Requests
├── alw_cons_exp: Data Entry
├── alw_pm_create: Create Projects
├── alw_lm: Location Management
├── alw_exp_task_plan: Expense & Task Designer
├── alw_pbc: IOU Request Processing
├── alw_ofz_tsk_desg: Office Expense & Task Designer
├── alw_est_edit: Estimation Lock Time Setting
├── alw_est_auth: Estimation Authorization
├── alw_est_appr: Estimation Approval
└── is_active: Account Setup & Maintenance
```

---

## 2. Authentication

### 2.1 Login Process
```
1. Open the Roky Holding application
2. Enter your username
3. Enter your password
4. Click "Login"
5. System validates credentials and loads user permissions
6. Redirected to Home Dashboard
```

### 2.2 Auto-Login Feature
```
1. System checks for stored token on app launch
2. If valid token exists, automatically logs in
3. If no token or expired token, manual login required
4. Auto-login uses stored credentials from previous session
```

### 2.3 Logout Process
```
1. Click logout icon in top-right corner of Home Dashboard
2. Confirm logout in dialog
3. System clears stored tokens and user data
4. Redirected to login screen
```

---

## 3. Home Dashboard

### 3.1 Dashboard Layout
The Home Dashboard displays available modules based on user permissions:

```
┌─────────────────────────────────────────────────────────┐
│ Header: Notifications, Layout Toggle, Logout           │
├─────────────────────────────────────────────────────────┤
│ Main Content: Permission-based Module Tiles            │
│ └── Only shows modules user has access to              │
└─────────────────────────────────────────────────────────┘
```

### 3.2 Available Modules (Based on Permissions)

#### Financial Operations
- **Approve Project IOU** (alw_auth)
- **Approve Office IOU** (alw_ofz_auth)
- **Pending Payment** (alw_req_pay)
- **Office Related Settlements** (alw_req_pay)
- **Project Related Settlements** (alw_req_pay)
- **IOU Request** (alw_pbc)
- **Office IOU Request** (alw_ofz_exp)
- **My IOU Request** (alw_prl)

#### Project Management
- **Project Management** (alw_pm_create)
- **Location Management** (alw_lm)
- **Data Entry** (alw_cons_exp)

#### Material & Estimation
- **Material Management** (alw_mm)
- **Estimation Creating** (alw_ec)
- **Estimation Lock Time Set** (alw_est_edit)
- **Estimation Request Approving** (alw_est_auth)

#### Planning & Design
- **Expense & Task Designer** (alw_exp_task_plan)
- **Office Expense & Task Designer** (alw_ofz_tsk_desg)

#### System Management
- **Permission Manager** (alw_pm)
- **Account Setup** (is_active)
- **Reminders** (is_active)
- **Maintenance** (alw_pm)

#### Reporting
- **Report View** (alw_rpt)

---

## 4. Available Modules

### 4.1 Project Management

#### Creating Projects
```
1. Click "Project Management" tile (requires alw_pm_create permission)
2. System loads existing projects list
3. Click "Add New Project" button
4. Fill in project details:
   - Tender Number
   - Project Name
   - Tender Cost
   - Client Name
   - Start Date
   - End Date
   - User Visibility
   - Active Status
5. Click "Save Project"
6. Project appears in active projects list
```

#### Project Operations
- **View Projects**: List all active projects
- **Edit Projects**: Modify existing project details
- **Delete Projects**: Remove projects from system
- **Project Status**: Track project lifecycle

### 4.2 Financial Operations

#### IOU Request Process
```
1. Click "IOU Request" tile (requires alw_pbc permission)
2. Select project from dropdown
3. Fill request details:
   - Payment Type (Cash/Cheque/Bank Transfer)
   - Amount
   - Purpose
   - Request Date
4. Upload supporting documents (images)
5. Submit request for approval
6. Track request status
```

#### Office IOU Request
```
1. Click "Office IOU Request" tile (requires alw_ofz_exp permission)
2. Fill office expense details
3. Upload receipts/documents
4. Submit for approval
5. Track approval status
```

#### Payment Approvals
```
1. Click "Approve Project IOU" (requires alw_auth permission)
2. View pending project payment requests
3. Review request details and documents
4. Approve or reject requests
5. Add approval comments if needed
```


### 4.3 Material Management

#### Material Operations
```
1. Click "Material Management" tile (requires alw_mm permission)
2. Available operations:
   - Add new materials
   - View material list
   - Edit material details
   - Track material usage
   - Manage material categories
```

### 4.4 Estimation System

#### Creating Estimations
```
1. Click "Estimation Creating" tile (requires alw_ec permission)
2. Select project for estimation
3. Add estimation items:
   - Work categories
   - Material requirements
   - Labor costs
   - Equipment costs
4. Calculate total estimation
5. Submit for approval
```

#### Estimation Approval Workflow
```
1. Click "Estimation Request Approving" (requires alw_est_auth permission)
2. View pending estimation requests
3. Review estimation details
4. Approve or reject with comments
5. Set approval status
```

#### Estimation Lock Time
```
1. Click "Estimation Lock Time Set" (requires alw_est_edit permission)
2. Set time restrictions for estimation modifications
3. Configure lock periods
4. Apply to specific projects or locations
```

### 4.5 Location Management

#### Location Operations
```
1. Click "Location Management" tile (requires alw_lm permission)
2. Available operations:
   - Add new locations
   - View location list
   - Edit location details
   - Assign locations to projects
   - Manage location access
```

### 4.6 Task & Expense Design

#### Expense & Task Designer
```
1. Click "Expense & Task Designer" tile (requires alw_exp_task_plan permission)
2. Design project tasks and expenses
3. Create task hierarchies
4. Define expense categories
5. Set task dependencies
```

#### Office Expense & Task Designer
```
1. Click "Office Expense & Task Designer" tile (requires alw_ofz_tsk_desg permission)
2. Design office-related tasks
3. Plan office expenses
4. Create office task workflows
```

### 4.7 Reporting System

#### Available Reports
```
1. Click "Report View" tile (requires alw_rpt permission)
2. Available report types:
   - Estimation Report
   - Material Report
   - Project Wise Request List
   - Project Wise Item Request List
   - Office IOU List
   - IOU List
   - Project Dashboard
   - Item Consume Report
   - Office IOU Items
```

#### Report Operations
- **Generate Reports**: Select report type and parameters
- **View Data**: Display report results
- **Export Data**: Download reports in various formats
- **Filter Results**: Apply date ranges and other filters

### 4.8 System Administration

#### Permission Management
```
1. Click "Permission Manager" tile (requires alw_pm permission)
2. View user list
3. Manage user permissions
4. Assign roles and access levels
5. Update user status
```

#### Account Setup
```
1. Click "Account Setup" tile (available to all active users)
2. Update personal information
3. Change password
4. Configure account settings
5. Update contact details
```

#### System Maintenance
```
1. Click "Maintenance" tile (requires alw_pm permission)
2. Database maintenance

```

#### Reminders
```
1. Click "Reminders" tile (available to all active users)
2. View system notifications
3. Check pending tasks
4. Review important alerts
5. Manage notification preferences
```

---

## 5. User Operations

### 5.1 Data Entry Operations

#### Project Data Entry
```
1. Navigate to "Data Entry" module (requires alw_cons_exp permission)
2. Select project for data entry
3. Enter construction data
4. Upload supporting documents
5. Submit for processing
```

### 5.2 Request Tracking

#### Track IOU Requests
```
1. Click "My IOU Request" tile (requires alw_prl permission)
2. View personal IOU requests
3. Check request status
4. View approval comments
5. Track payment processing
```

#### Track Payment Requests
```
1. Navigate to payment request modules
2. View request history
3. Check approval status
4. Monitor processing timeline
5. View settlement details
```

### 5.3 Document Management

#### Image Upload
```
1. Select image upload option in relevant modules
2. Choose image file from device
3. System uploads to server
4. Image attached to request/record
5. View uploaded images in request details
```

#### Document Review
```
1. Access request details
2. View attached documents
3. Download documents if needed
4. Review document status
5. Verify document completeness
```

---

## 6. Troubleshooting

### 6.1 Common Issues

#### Login Problems
```
Problem: Cannot login
Solution:
1. Check username and password
2. Verify internet connection
3. Clear app cache
4. Contact administrator for account issues
```

#### Permission Issues
```
Problem: Cannot access module
Solution:
1. Check user permissions
2. Contact administrator for access
3. Verify account status
4. Request permission updates
```

#### Data Loading Issues
```
Problem: Data not loading
Solution:
1. Check internet connection
2. Refresh the screen
3. Log out and log back in
4. Clear app cache
```

### 6.2 Error Messages

#### Common Error Messages
```
"Permission Denied"
- Solution: Contact administrator for access rights

"Network Error"
- Solution: Check internet connection

"Session Expired"
- Solution: Log in again

"Data Not Found"
- Solution: Check search criteria
```

### 6.3 Getting Help

#### Support Options
```
1. Contact System Administrator
2. Check user permissions
3. Review system documentation
4. Contact technical support
```

---

## 7. System Features

### 7.1 Security Features
- **Token-based Authentication**: Secure API communication
- **Permission-based Access**: Role-based module access
- **Data Validation**: Input validation and sanitization

### 7.2 User Interface Features
- **Responsive Design**: Adapts to different screen sizes
- **Permission-based UI**: Only shows accessible modules
- **Real-time Updates**: Live data synchronization
- **Image Upload**: Document attachment capabilities

### 7.3 Data Management Features
- **Project Tracking**: Complete project lifecycle management
- **Financial Control**: IOU and payment processing
- **Material Management**: Inventory and usage tracking
- **Reporting**: Comprehensive reporting system

---

## Conclusion

This user guide reflects the actual functionality available in the Roky Holding application based on code analysis. The system provides:

- **Comprehensive Project Management**: Full project lifecycle support
- **Financial Operations**: IOU requests, approvals, and settlements
- **Material Management**: Inventory and usage tracking
- **Estimation System**: Cost estimation and approval workflows
- **Reporting**: Multiple report types for analysis
- **User Management**: Permission-based access control

### Key Success Factors
1. **Understand Permissions**: Know your access levels
2. **Follow Workflows**: Use proper approval processes
3. **Document Management**: Upload required documents
4. **Regular Monitoring**: Track request and project status
5. **System Maintenance**: Keep account information updated

---

**Document Version**: 1.0  
**Based on Code Analysis**: August 2025  
**Document Owner**: K.L Aruna Shantha

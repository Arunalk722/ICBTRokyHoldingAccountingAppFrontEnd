# Roky Holding - Project Management App

![Flutter](https://img.shields.io/badge/Flutter-3.6.0-blue.svg)
![Dart](https://img.shields.io/badge/Dart-SDK-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-green.svg)

**Roky Holding** is a comprehensive Flutter-based mobile and desktop application designed for enterprise-level project management, estimation, payment processing, and reporting. Built for business users involved in construction project management, budgeting, and approval workflows.

## 🚀 Features

### 🔐 Authentication & User Management
- **Secure Login System**: JWT token-based authentication with auto-login
- **User Registration**: Complete user onboarding process
- **Password Management**: Reset password and account setup functionality
- **Permission-Based Access**: Role-based access control for different user types

### 📊 Project Management
- **Project Creation & Management**: Complete project lifecycle management
- **Location Management**: Multi-location project support
- **Material Management**: Comprehensive material catalog and inventory
- **Estimation Management**: Detailed project cost estimation and budgeting
- **Task Planning**: Advanced task design and planning tools

### 💰 Payment & Billing System
- **Payment Requests**: Office and project-based payment request workflows
- **Bill Management**: Invoice creation and bill processing
- **Approval Workflows**: Multi-level authorization and approval system
- **IOU Management**: IOU tracking and settlement system
- **Budget Tracking**: Real-time budget monitoring and variance analysis

### 📈 Reporting & Analytics
- **Project Dashboards**: Real-time project performance dashboards
- **Consumption Reports**: Material and cost consumption analysis
- **Export Functionality**: CSV and PDF export capabilities
- **Visual Analytics**: Charts and graphs for data visualization
- **Estimation vs Request Analysis**: Comparative analysis tools

### 🔔 Notifications & Reminders
- **Alert System**: Real-time notifications for pending approvals
- **Reminder Management**: Task and deadline reminder system
- **Status Updates**: Automated status change notifications

### 🌐 Cross-Platform Support
- **Mobile**: Android and iOS native support
- **Web**: Progressive Web App (PWA) capabilities
- **Desktop**: Windows, macOS, and Linux support

## 🏗️ Architecture

### Project Structure
```
lib/
├── env/                     # Environment utilities and shared components
│   ├── platform_ind/        # Platform-specific implementations (CSV export, image picker)
│   ├── DialogBoxs.dart      # Custom dialog components
│   ├── api_info.dart        # API configuration and endpoints
│   ├── input_widget.dart    # Custom input widgets
│   ├── user_data.dart       # User data management
│   └── ...
├── md_01/                   # Authentication Module
│   ├── login.dart           # Login functionality
│   ├── registration.dart    # User registration
│   ├── reset_password.dart  # Password reset
│   └── account_setup.dart   # Account configuration
├── md_02/                   # Home & Maintenance Module
│   ├── home_page.dart       # Main dashboard
│   ├── app_maintenance.dart # App maintenance tools
│   └── permission_management.dart
├── md_03/                   # Estimation & Project Management
│   ├── project_management.dart
│   ├── project_estimation_management.dart
│   ├── material_management.dart
│   ├── location_management.dart
│   └── ...
├── md_04/                   # Payment Request Module
│   ├── office_payment_request_form.dart
│   ├── project_bill_request.dart
│   ├── auth_project_payment_request.dart
│   └── ...
├── md_05/                   # Approval & Authorization Module
│   ├── payment_process_all.dart
│   ├── approve_project_payment_dialog_box.dart
│   └── ...
├── md_06/                   # Reporting & Analytics Module
│   ├── project_wise_dashboard.dart
│   ├── report_list.dart
│   ├── iou_settlements.dart
│   └── ...
├── md_07/                   # Reminders Module
│   └── reminders.dart
└── main.dart               # Application entry point
```

### Design Patterns & Architecture
- **Modular Architecture**: Clear separation of concerns across functional modules
- **State Management**: Flutter's built-in state management with StatefulWidget
- **API Integration**: HTTP-based REST API communication
- **Cross-Platform**: Platform-conditional implementations for web/mobile features
- **Responsive Design**: Adaptive UI for different screen sizes

## 🛠️ Tech Stack

### Frontend Framework
- **Flutter SDK**: ^3.6.0
- **Dart**: Latest stable version

### Key Dependencies
```yaml
# Core Flutter
flutter:
  sdk: flutter
cupertino_icons: ^1.0.8

# HTTP & API
http: ^1.3.0
shared_preferences: ^2.5.2
json_annotation: ^4.8.1

# UI Components
font_awesome_flutter: ^10.8.0
fl_chart: ^0.70.2
flutter_typeahead: ^5.2.0
flutter_form_builder: ^9.7.0
syncfusion_flutter_charts: ^29.1.35

# File Handling
image_picker: ^1.1.2
file_picker: ^10.0.0
path_provider: ^2.1.5

# Export & Printing
csv: ^6.0.0
pdf: ^3.11.3
printing: ^5.11.0

# Utilities
intl: ^0.19.0
pattern_formatter: ^4.0.0
url_launcher: ^6.1.11
flutter_downloader: ^1.12.0
```

### Backend Integration
- **API Endpoints**: RESTful API integration
- **Authentication**: JWT token-based security
- **Data Format**: JSON for API communication
- **File Upload**: Multi-part form data support

## 📱 Installation & Setup

### Prerequisites
- Flutter SDK (3.6.0 or higher)
- Dart SDK (bundled with Flutter)
- IDE: Android Studio, VS Code, or IntelliJ IDEA
- Git for version control

### Development Environment Setup

1. **Install Flutter SDK**
   ```bash
   # Download Flutter SDK from https://flutter.dev/docs/get-started/install
   # Add Flutter to your PATH
   ```

2. **Verify Installation**
   ```bash
   flutter doctor
   ```

3. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd roky_holding
   ```

4. **Install Dependencies**
   ```bash
   flutter pub get
   ```

5. **Configure API Endpoints**
   - Update API URLs in `lib/env/api_info.dart`
   - Configure environment-specific settings

### Running the Application

#### Mobile Development
```bash
# Android
flutter run -d android

# iOS (macOS only)
flutter run -d ios
```

#### Web Development
```bash
flutter run -d chrome
```

#### Desktop Development
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

## 🚀 Building for Production

### Mobile Builds
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (macOS only)
flutter build ios --release
```

### Web Build
```bash
flutter build web --release
```

### Desktop Builds
```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 🔧 Configuration

### API Configuration
Update the API endpoints in `lib/env/api_info.dart`:

```dart
class APIHost {
  final String apiURL = 'https://your-api-domain.com/api';
  final String appVersion = '4.0.1';
}
```

### Environment Settings
- **Development**: Local API endpoints
- **Production**: Live server endpoints
- **Staging**: Test environment configuration

### Platform-Specific Assets
- **Android**: Update `android/app/src/main/AndroidManifest.xml`
- **iOS**: Configure `ios/Runner/Info.plist`
- **Web**: Modify `web/index.html` and `web/manifest.json`

## 📊 Key Features Breakdown

### 1. Project Estimation System
- Create detailed project estimations
- Material quantity and cost calculations
- Multi-level approval workflows
- Estimation vs actual cost analysis

### 2. Payment Request Management
- Office payment requests
- Project-specific payment processing
- Authorization and approval chains
- Real-time status tracking

### 3. Reporting & Analytics
- Project-wise dashboards
- Material consumption reports
- Budget variance analysis
- Exportable reports (CSV/PDF)

### 4. Material & Inventory Management
- Comprehensive material catalog
- Inventory tracking
- Cost management
- Supplier information

## 🔒 Security Features

- **JWT Authentication**: Secure token-based authentication
- **Role-Based Access**: Permission-based feature access
- **Data Validation**: Input sanitization and validation
- **Secure API Communication**: HTTPS encrypted communication
- **Session Management**: Automatic token refresh and logout

## 📱 User Interface

### Design Principles
- **Material Design**: Following Google's Material Design guidelines
- **Responsive Layout**: Adaptive UI for different screen sizes
- **Accessibility**: Support for screen readers and accessibility features
- **Intuitive Navigation**: User-friendly navigation patterns
- **Custom Components**: Reusable UI components for consistency

### Supported Platforms
- **Mobile**: iOS 12+, Android API 21+
- **Web**: Modern browsers (Chrome, Firefox, Safari, Edge)
- **Desktop**: Windows 10+, macOS 10.14+, Ubuntu 18.04+

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Create a Pull Request

### Development Guidelines
- Follow Dart/Flutter coding standards
- Write unit tests for new features
- Update documentation for API changes
- Use meaningful commit messages

## 📄 License

This project is private and proprietary to Roky Holdings.

## 📞 Support

For technical support and inquiries:
- **Email**: support@rokyholdings.com
- **Website**: https://rokyholdings.com
- **Documentation**: Internal documentation portal

## 🔄 Version History

- **v4.0.1** (Current): Enhanced reporting features and bug fixes
- **v4.0.0**: Major UI overhaul and new payment processing system
- **v3.x.x**: Legacy versions with basic project management features

---

**Built with ❤️ using Flutter for Roky Holdings**

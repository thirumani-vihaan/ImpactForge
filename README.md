# <img src="assets/images/logo.png" width="48" height="48" valign="middle"/> ImpactForge

A modern, scalable, and responsive **Volunteer Management & Community Engagement Platform** built with **Flutter** and **Firebase**. 

ImpactForge empowers organizations to coordinate volunteer activities in real-time, verify task submissions securely, and gamify community contributions through progress dashboards and leaderboards. Designed with a clean, responsive layout suited for both web and mobile clients.

---

## 🚀 Key Features

*   **Secure Authentication**: Dual-mode login supporting Email/Password and Google OAuth.
*   **Real-time Task Allocation**: Interactive task boards for volunteers to discover and join local community drives.
*   **Multimedia Evidence Verification**: Secure report submission with image uploading for task completion verification.
*   **Impact Analytics Dashboard**: Real-time charts demonstrating volunteer metrics, hours spent, and overall community impact.
*   **Gamification & Leaderboard**: Global ranking system based on active points, milestones, and reward badges.
*   **Administrative Suite**: Dedicated admin dashboard for creating tasks, reviewing submissions, elevating volunteer roles, and monitoring operations.

---

## 🛠️ Technology Stack

*   **Frontend**: Flutter (Dart)
*   **State Management & Routing**: GetX (reactive state, dependency injection, and clean hash-based web routing)
*   **Styling & UI**: Material 3 UI design, custom glassmorphic cards, responsive overlays, and custom Google Fonts typography
*   **Database**: Cloud Firestore (Real-time NoSQL database)
*   **Backend Storage**: Firebase Storage (Secure hosting for submitted completion images)
*   **Security**: Attribute-Based Access Control (ABAC) enforced via granular Cloud Firestore Security Rules

---

## 🏗️ System Architecture

The project follows a clean architecture separating the presentation layer, reactive state controllers, and the cloud data source layer.

```mermaid
graph TD
    %% Styling
    classDef default fill:#f9f9f9,stroke:#333,stroke-width:1px;
    classDef presentation fill:#e1f5fe,stroke:#0288d1,stroke-width:1.5px;
    classDef controller fill:#e8f5e9,stroke:#388e3c,stroke-width:1.5px;
    classDef backend fill:#fffde7,stroke:#fbc02d,stroke-width:1.5px;

    subgraph Presentation [Presentation Layer - Flutter]
        UI[App Shell / Screens]:::presentation
    end

    subgraph State [State & Business Logic - GetX]
        AC[AuthController]:::controller
        TC[TaskController]:::controller
        LC[LeaderboardController]:::controller
    end

    subgraph Cloud [Data Source Layer - Firebase]
        FA[Firebase Authentication]:::backend
        FS[(Cloud Firestore)]:::backend
        FST[(Firebase Storage)]:::backend
    end

    %% Interactions
    UI <--> AC
    UI <--> TC
    UI <--> LC

    AC <--> FA
    TC <--> FS
    LC <--> FS
    
    UI -.-> FST
    FST -.-> FS
```

---

## 📊 Database Schema (Firestore Collections)

```
├── users (Key: email)
│   ├── name (String)
│   ├── role (String: 'volunteer' | 'admin')
│   ├── points (Number)
│   └── joinDate (Timestamp)
│
├── tasks (Key: auto-generated ID)
│   ├── title (String)
│   ├── description (String)
│   ├── pointsAwarded (Number)
│   └── deadline (Timestamp)
│
├── active_tasks (Key: auto-generated ID)
│   ├── taskId (String)
│   ├── userEmail (String)
│   ├── status (String: 'ongoing' | 'submitted' | 'verified')
│   └── assignedAt (Timestamp)
│
└── submissions (Key: auto-generated ID)
    ├── taskId (String)
    ├── userEmail (String)
    ├── description (String)
    ├── imageUrl (String)
    └── submittedAt (Timestamp)
```

---

## 📥 Getting Started

### Prerequisites
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0.0 or higher)
*   Dart SDK (v3.0.0 to v4.0.0)

### Installation & Run

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/impactforge.git
   cd impactforge
   ```

2. Retrieve package dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   *   Place your `google-services.json` inside `android/app/` for Android.
   *   Web parameters are preconfigured inside `lib/constants/app_config.dart`.

4. Build and run locally:
   ```bash
   # Run app in default browser
   flutter run -d chrome
   ```

---

## 📱 Application Preview

Once you place your captured screenshots in the `screenshots/` directory, they will be displayed here in high resolution:

### Onboarding & Security

| Splash Screen | Login Screen | Signup Screen |
| :---: | :---: | :---: |
| <img src="screenshots/01_splash.png" width="220" alt="Splash Screen Preview"/> | <img src="screenshots/02_login.png" width="220" alt="Login Screen Preview"/> | <img src="screenshots/03_signup.png" width="220" alt="Signup Screen Preview"/> |

### Volunteer Lifecycle

| Home Dashboard | Tasks List | Task Details |
| :---: | :---: | :---: |
| <img src="screenshots/04_home.png" width="220" alt="Home Dashboard Preview"/> | <img src="screenshots/05_tasks.png" width="220" alt="Tasks List Preview"/> | <img src="screenshots/06_task_details.png" width="220" alt="Task Details Preview"/> |

### Submissions & Leaderboard

| Task Submission | Impact Analytics | Leaderboard |
| :---: | :---: | :---: |
| <img src="screenshots/07_task_submission.png" width="220" alt="Task Submission Preview"/> | <img src="screenshots/08_impact_analytics.png" width="220" alt="Impact Analytics Preview"/> | <img src="screenshots/11_leaderboard.png" width="220" alt="Leaderboard Preview"/> |

### User Settings & Admin Dashboard

| Profile Screen | Edit Profile | Account Settings | Admin Dashboard |
| :---: | :---: | :---: | :---: |
| <img src="screenshots/09_profile.png" width="160" alt="Profile Screen Preview"/> | <img src="screenshots/10_edit_profile.png" width="160" alt="Edit Profile Preview"/> | <img src="screenshots/12_settings.png" width="160" alt="Account Settings Preview"/> | <img src="screenshots/13_admin_dashboard.png" width="160" alt="Admin Dashboard Preview"/> |

---

## 🛡️ License
Distributed under the MIT License. See `LICENSE` for more information.

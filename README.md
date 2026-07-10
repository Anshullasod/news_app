<!--Global News Application
A cross-platform mobile and web application built with Flutter that provides real-time news updates with seamless authentication and filtering capabilities.

🚀 Overview
The Global News App is designed to offer a clean, responsive, and efficient news-reading experience. It allows users to authenticate via email or Google Sign-In, browse categorized news, search for specific topics, and filter articles by date.

🛠 Tech Stack
Framework: Flutter (Dart)

Authentication: Firebase Auth

Platform: Android, Web

Development Environment:  Android Studio
✨ Key Features
Robust Authentication: Secure sign-up/login system including "Sign in with Google."

Cross-Platform UI: Fully responsive design that adapts seamlessly between desktop web browsers and mobile devices.

Advanced Filtering: Sort news by popularity, business category, top headlines, or specific dates.

Global Search: Real-time search functionality to find specific news articles quickly.

Error Resiliency: Implemented custom "Retry" logic to handle network interruptions gracefully.

📱 Application Demo
https://www.linkedin.com/posts/anshullasod_flutter-mobiledevelopment-webdevelopment-ugcPost-7469392543256956928-Vibg/?utm_source=share&utm_medium=member_desktop&rcm=ACoAAFV9mfQBj-4VHnvpJ5FICl3A2XVGaLLkWSA

Clone the repository:

Bash
git clone https://github.com/Anshullasod/news_app.git

2. **Navigate to the project folder:**
   ```bash
cd your-repo-name
Install dependencies:

flutter pub get


4. **Run the application:**
   ```bash
   flutter run
🤝 Contribution
This project was developed during my 4th semester of B.Tech Computer Science and Engineering. I am actively looking to optimize and expand its features. Suggestions, feedback, and pull requests are highly encouraged!

Developed by Anshul Lasod
College of Technology and Engineering (CTAE)
[Link to your LinkedIn Profile]-->
# 📰 Daily News 

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=white)
![GetX](https://img.shields.io/badge/GetX-FF0000?style=for-the-badge&logo=dart&logoColor=white)
![REST API](https://img.shields.io/badge/REST_API-007BFF?style=for-the-badge&logo=json&logoColor=white)

A high-performance, cross-platform news aggregation application built with Flutter. The app fetches real-time global news, features secure Firebase authentication, and employs advanced API optimization techniques to ensure a seamless and cost-effective user experience.

## 📱 Visual Walkthrough
https://www.linkedin.com/posts/anshullasod_flutter-mobiledevelopment-webdevelopment-ugcPost-7469392543256956928-Vibg/?utm_source=share&utm_medium=member_desktop&rcm=ACoAAFV9mfQBj-4VHnvpJ5FICl3A2XVGaLLkWSA

## 🚀 Core Features
* **Secure Authentication:** Multi-layered login system utilizing Firebase (Email/Password & Google Sign-In).
* **Smart Search Engine:** Live news searching with automated debouncing to optimize backend calls.
* **Dynamic Filtering:** Categorize news instantly by 'Top News', 'Trending', and sort chronologically by date.
* **Fluid UI/UX:** Responsive design featuring Shimmer loading effects for a premium feel during network delays.
* **Personalized Profiles:** Dedicated user profile module integrated with cloud databases to manage user states.

## 🧠 Engineering Highlights

### 1. API Cost Optimization (Debouncing)
Standard search bars fire an API request for every keystroke, which rapidly exhausts third-party API tokens and increases costs. I engineered a custom search logic featuring:
* **Debounce Timer:** The app waits until the user pauses typing before firing the API call.
* **3-Word Minimum Threshold:** Queries are only executed when they hold semantic value, blocking useless single-character requests. 
* *Result:* Reduced redundant API calls by over 70%, making the app production-ready and highly cost-efficient.

### 2. Firebase Architecture
* Implemented secure OAuth flows and managed user sessions via Firebase Auth.
* Integrated seamless data fetching and real-time state updates for the Profile Module.

## 🛠️ Tech Stack
* **Frontend:** Flutter, Dart
* **State Management:** GetX (or mention Provider/Riverpod if you used that)
* **Backend / BaaS:** Firebase Authentication, Firestore
* **Network:** HTTP, REST APIs

## ⚙️ Local Setup
1. Clone the repository: `git clone https://github.com/Anshullasod/news_app.git`
2. Install dependencies: `flutter pub get`
3. Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the respective directories.
4. Add your News API key in the environment variables/constants file.
5. Run the app: `flutter run`

## 📬 Contact
* **LinkedIn:** www.linkedin.com/in/anshullasod
* **Email:** Anshullasod@gmail.com 

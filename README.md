# 🌾 Farmer AI — Smart Agriculture with AI & ML

**Farmer AI** is a revolutionary, AI-powered smart farming assistant designed to empower Indian farmers with actionable insights. The app brings together crop calendars, real-time market data, soil health analysis, plant disease detection, and a virtual farming assistant — all in one cross-platform mobile solution.

Built with **Flutter**, **Firebase**, and **TensorFlow Lite**, Farmer AI makes cutting-edge agriculture tools accessible to every farmer — digitally, intelligently, and intuitively.

---

## 🧠 What is Farmer AI?

Farmer AI is a full-stack, AI-driven agriculture assistant that modernizes farming through:

- 🌾 AI-based plant disease detection (image classification)
- 📈 Live mandi (market) price tracking
- 🗓️ Region-specific crop calendars
- 🧪 Soil health–based crop and fertilizer recommendations
- 🤖 Real-time chatbot for personalized farming help

---

## 🧭 Chosen Track

**🟢 AI/ML (Artificial Intelligence & Machine Learning)**

This project tackles real-world agricultural problems using:

- ✅ On-device ML model (TensorFlow Lite) for plant disease detection
- ✅ AI chatbot (“Harivest”) for natural-language-based farming Q&A
- ✅ Soil and crop recommendation engine powered by input-driven analysis

---

## ❗ The Problem We’re Solving

Over **150 million Indian farmers** still rely on traditional methods, facing challenges like:

- ❌ Lack of real-time crop insights and weather updates
- ❌ Limited access to soil diagnostics or scientific planning tools
- ❌ No centralized platform for price tracking and disease detection
- ❌ Insufficient awareness of government schemes or community support

**Farmer AI** addresses these issues by putting powerful tools in farmers' hands — in their own language, with real-time intelligence.

---

## 🏆 Bounties & Challenges Completed

- ✅ Created a custom **team mascot** inspired by the Star Wars Jedi theme
- ✅ Embedded **Star Wars-themed Easter eggs** for an engaging and fun user experience
- ✅ Implemented **3D navigation transitions** to enhance app fluidity and UI appeal

---

## 🚀 Features

### 👨‍🌾 Community Chat
- Real-time farmer-to-farmer discussions
- Share tips on fertilizers, pests, crops, and more

### 🗓️ Crop Calendar
- Dynamic, state-wise calendar
- Know what to sow and when, based on region

### 📊 Live Market Dashboard
- Real-time prices for key crops:
  - Basmati, Wheat, Potato, Onion, Tomato, Maize

### 🧪 Soil Health Recommendations
Enter key parameters:
- Soil Moisture
- Temperature
- pH Level
- Nitrogen Level  
➡️ Receive smart suggestions on:
- Crop choices
- Fertilizer usage
- Farming strategies

### 📸 AI Disease Detection
- Upload or take plant photos
- Detect crop type and disease instantly via ML model
- Get personalized treatment suggestions

### 🤖 Harivest — Your AI Farming Bot
- Ask real-time questions on farming, fertilizers, diseases, weather, etc.
- Powered by generative AI
- Star Wars–inspired voice and personality

### 🌦️ Weather Forecast
- Real-time weather updates via WeatherAPI
- Search by city
- Fun Star Wars-themed surprises for fans

### ⏰ Scheme Reminder System
- 🔔 New Schemes: Recently launched government support
- 📜 Previous Schemes: Past programs and subsidy history

### ⚙️ Settings Panel
- Edit profile and password
- Customize language and measurement units
- Manage notifications
- Firebase-authenticated sign-out

---

## 🛠️ Tech Stack

| Layer         | Technology                                  |
|---------------|---------------------------------------------|
| **Frontend**  | Flutter (Dart)                              |
| **Backend**   | Firebase Auth, Firestore, Firebase Storage  |
| **ML Model**  | TensorFlow Lite (on-device image detection) |
| **APIs**      | WeatherAPI, Custom Market Price API         |
| **Cloud**     | Firebase Hosting & Firestore                |

---

## 📁 Installation

git clone https://github.com/pranav14-1/HariVest.git
cd HariVest
flutter pub get

---

## ✅ Firebase Setup

To run HariVest with Firebase, follow these steps:

1. Go to [console.firebase.google.com](https://console.firebase.google.com/) and create a new Firebase project.
2. Register your app(s):
   - For Android: Use your app’s package name
   - For iOS: Use your app’s bundle ID
3. Download the Firebase config files:
   - Place `google-services.json` in `android/app/`
   - Place `GoogleService-Info.plist` in `ios/Runner/`
4. Enable **Authentication** in Firebase Console:
   - Go to **Authentication → Sign-in method → Enable Email/Password**
5. Configure **Firestore Database**:
   - Enable Firestore in test mode or secure it with appropriate rules.
6. (Optional) Enable **Firebase Storage** if your app uploads images (e.g., plant photos for ML analysis).


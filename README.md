# Habit Tracking App

Welcome to the Habit Tracking App! This app allows users to track their daily habits, sign up, sign in, and store data locally using Hive for persistent storage.

## 💻 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/habit-tracking-app.git
cd habit-tracking-app
```

### 2. Install Dependencies

Run the following command to install the required dependencies:

```bash
flutter pub get
```

### 3. Run the App

Once everything is set up, run the app on your emulator or physical device:

```bash
flutter run
```

---

## 🚀 How the App Works

### 1. **Sign Up & Sign In**

The app uses **Hive** for local storage to manage user credentials:

- **Sign Up**: Users can sign up by providing a username and password. The credentials are saved locally using Hive.
- **Sign In**: Users can sign in using the saved credentials, and the app will load the appropriate user data.

### 2. **Home Screen**

Once logged in, the user is taken to the **Home** screen:

- Displays a personalized welcome message with the user's name.
- Allows users to manage their habits by viewing and interacting with the habit list.
- Users can add new habits using a modal.
- Habits can be marked with a rating system using a **PannableRatingBar** to track daily progress.

### 3. **Habit Tracking**

Users can:

- **Add a habit**: Use the floating action button to add a new habit, including details like the habit name and frequency.
- **Update habit**: The **PannableRatingBar** allows users to update the habit's progress by adjusting a rating. This value is saved locally and in Firestore.

### 4. **Logout**

A logout button is available in the app bar. When clicked, it signs the user out and redirects them to the login screen.

---

## 🧑‍💻 Technologies Used

- **Flutter** for building the app.
- **Hive** for local storage of user data and habits.
- **Firebase Firestore** for storing and syncing habit data (optional).
- **Cupertino Widgets** for iOS-style modals and interactions.
- **PannableRatingBar** for interactive rating of habits.

---

### ✨ Enjoy tracking your habits!

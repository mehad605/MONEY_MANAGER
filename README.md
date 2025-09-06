# Money Manager

![Platform: Android](https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android)
![Framework: Flutter](https://img.shields.io/badge/Framework-Flutter-02569B?style=for-the-badge&logo=flutter)
![Language: Dart](https://img.shields.io/badge/Language-Dart-0175C2?style=for-the-badge&logo=dart)

**Money Manager** is an Android application built with Flutter that helps users track their daily income and expenses.  
The app provides clear financial insights through charts and summaries, making it easy to identify spending patterns, highlight high-expense days, and plan finances effectively.  
By categorizing both income and expenses, it allows users to see which areas contribute the most income and which ones consume the most resources.

---

## 🚀 Key Features

- **Income & Expense Tracking**: Log daily financial transactions to maintain a detailed money flow record.  
- **Data Visualization**: View spending trends with a simple chart on the homepage.  
- **Transaction Categorization**: Organize transactions into main categories (Income, Expense) and subcategories for detailed analysis.  
- **Monthly Overview**: Quickly filter and view transactions for a selected month.  
- **Personalization**: The app greets you by name, which can be updated anytime in settings.  
- **Data Management**: Delete individual transactions or clear all app data when needed.  

---

## 🛠 Tech Stack & Dependencies

The app is built using the following technologies:

- **Platform**: Android  
- **Framework**: Flutter  
- **Language**: Dart  
- **Database**: Hive (`hive: ^2.0.4`, `hive_flutter: ^1.1.0`) for local data persistence.  
- **State Management**: Shared Preferences (`shared_preferences: ^2.0.8`) for storing simple key-value data like the user’s name.  
- **UI & Charting**:  
  - `cupertino_icons: ^1.0.2` for iOS-style icons.  
  - `fl_chart: ^0.40.2` to render financial charts.  
- **Assets**:  
  - `flutter_launcher_icons: ^0.9.3` for launcher icon management.  
  - Custom images and fonts stored in the `assets` folder and registered in `pubspec.yaml`.  

---

## 📱 How It Works

### Onboarding
- On first launch, the app prompts you to enter your name, which is stored locally.  
- On subsequent launches, it loads your name and goes directly to the homepage.  

### Homepage
- A personalized greeting and quick navigation to settings.  
- A month selector to filter transactions.  
- A summary card showing **total balance**, **income**, and **expenses** for the selected month.  
- A line chart visualizing expenses over time (once data spans at least two dates).  
- Transaction lists available in detail or grouped by category.  

### Adding Transactions
- Tap the floating action button to add a transaction.  
- Enter amount, description, date, and select category (income or expense with subcategories).  
- Data is saved locally using Hive.  

### Settings
- **Change Name**: Update the stored name anytime.  
- **Clean Data**: Wipe all transactions after confirmation.  

---

## ⚙️ Setup and Installation

To run the project locally, follow these steps:

### Prerequisites
- Install the [Flutter SDK](https://docs.flutter.dev/get-started/install).  

### Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/mehad605/MONEY_MANAGER
   ```
2. Navigate into the project directory:
    ```sh
    cd MONEY_MANAGER
    ```


3. Install dependencies:
    ```sh
    flutter pub get
    ```

4. Run the application:
    ```sh
    flutter run
    ```




# Money Manager

![Platform: Android](https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android)
![Framework: Flutter](https://img.shields.io/badge/Framework-Flutter-02569B?style=for-the-badge&logo=flutter)
![Language: Dart](https://img.shields.io/badge/Language-Dart-0175C2?style=for-the-badge&logo=dart)

[cite_start]Money Manager is an Android application built with Flutter that helps users track their daily income and expenses[cite: 1, 2, 3, 9]. [cite_start]The app presents financial data graphically, allowing users to quickly understand their spending patterns, identify days with high expenses, and plan accordingly[cite: 10, 11]. [cite_start]By categorizing both income and expenses, it provides insights into which areas generate the most income and which ones consume the most funds[cite: 12, 13].

***

## Key Features

* [cite_start]**Income & Expense Tracking**: Log daily financial transactions to keep a detailed record of your money flow[cite: 9].
* [cite_start]**Data Visualization**: A graph on the homepage visualizes spending, helping to identify trends and high-expense days[cite: 10, 159].
* [cite_start]**Transaction Categorization**: Transactions are divided into main categories (Income, Expense) and further broken down into sub-categories for granular analysis[cite: 12, 180].
* [cite_start]**Monthly Overview**: Easily select and view all transactions for a specific month[cite: 152].
* [cite_start]**Personalization**: The app greets you by name, which can be updated in the settings[cite: 147, 192].
* [cite_start]**Data Management**: Users have the ability to delete individual transactions or completely wipe all app data[cite: 172, 191].

***

## Tech Stack & Dependencies

The project utilizes the following technologies and packages:

* [cite_start]**Platform**: Android [cite: 2]
* [cite_start]**Framework**: Flutter [cite: 3, 15]
* [cite_start]**Language**: Dart [cite: 4]
* [cite_start]**Database**: Hive (`hive: ^2.0.4`, `hive_flutter: ^1.1.0`) is used for local data persistence[cite: 19].
* [cite_start]**State Management**: Shared Preferences (`shared_preferences: ^2.0.8`) is used for storing simple key-value data like the user's name[cite: 20].
* **UI & Charting**:
    * [cite_start]`cupertino_icons: ^1.0.2`: Provides a set of iOS-style icons[cite: 16].
    * [cite_start]`fl_chart: ^0.40.2`: Renders the financial chart on the homepage[cite: 17].
* **Assets**:
    * [cite_start]`flutter_launcher_icons: ^0.9.3`: Manages the app's launcher icon[cite: 18].
    * [cite_start]Custom images and fonts are stored in the `assets` folder and registered in `pubspec.yaml`[cite: 21].

***

## How It Works

### Onboarding
[cite_start]On the first launch, the app prompts the user to enter a name, which is then saved using shared preferences[cite: 143]. [cite_start]On subsequent startups, the app retrieves the name and navigates directly to the homepage[cite: 146].

### Homepage
[cite_start]The main screen welcomes the user and provides access to the settings page[cite: 147, 148]. [cite_start]It features a month selector to filter transactions[cite: 152]. [cite_start]A central card displays the total balance, along with a summary of total income and expenses for the chosen month[cite: 155]. [cite_start]A line chart visualizes expenses over time, which renders once data for at least two different dates is available[cite: 161]. [cite_start]Below the chart, transactions can be viewed as a complete list or grouped by category[cite: 168, 169].

### Adding Transactions
[cite_start]A floating action button opens the "Add Transaction" page[cite: 174]. [cite_start]Here, users can input an amount, add a descriptive note, select a date, and classify the transaction as either income or expense with a specific sub-category[cite: 177, 178, 179, 180, 181]. [cite_start]Upon submission, the data is saved to the Hive database[cite: 185].

### Settings
The settings page offers two main functions:
1.  [cite_start]**Change Name**: Allows the user to update their name stored in shared preferences[cite: 192].
2.  [cite_start]**Clean Data**: Deletes all transaction data from the database after a confirmation warning[cite: 190, 191].

***

## Setup and Installation

To get a local copy up and running, follow these simple steps.

### Prerequisites

* [cite_start]You must have the Flutter SDK installed on your machine[cite: 22]. Follow the official [Flutter installation guide](https://docs.flutter.dev/get-started/install) for instructions.

### Installation

1.  Clone the repository to your local machine:
    ```sh
    git clone [https://github.com/your_username/your_repository.git](https://github.com/your_username/your_repository.git)
    ```
2.  Navigate into the project directory:
    ```sh
    cd your_repository
    ```
3.  Install the required dependencies:
    ```sh
    flutter pub get
    ```
4.  Run the application:
    ```sh
    flutter run
    ```

[cite_start]It is also suggested to install the Flutter and Dart extensions for VS Code to improve code readability and development experience[cite: 5, 7].
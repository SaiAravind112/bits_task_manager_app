# Assignment: Flutter App with Back4App Integration

## Introduction

### Assignment Description:
- In this assignment, We will create a Flutter app that connects to Back4App, a Backend-as-a-Service (BaaS) platform, to manage tasks.
- We will be creating for 
    + Setting up the Back4App backend
    + Creating the Flutter app
    + Implementing the necessary functionality to interact with the backend.

## **Pre-Requisites**

### **Install Hombrew:**
- It's a package manager for macOS. If you don't have Hombrew installed, you can do so by running this command in your terminal:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Hombrew/install/HEAD/install.sh)"
```

### **Install Flutter:**
- You can install Flutter using the command-line terminal on your macOS. Here are the steps:
- Open your terminal.
- Run the following command to download Flutter and place it in your home directory:
```bash
git clone https://github.com/flutter/flutter.git ~/flutter
```
- Add the Flutter executable to your system's PATH. You can do this by editing your shell profile configuration file (e.g., `.zshrc` for Zsh or `.bash_profile` for Bash). Use a text editor to open the appropriate file and add the following line:
```bash
export PATH="$PATH:$HOME/flutter/bin"
```
- To apply the changes to your current terminal session, either restart your terminal or run:
```bash
 source ~/.zshrc  # For Zsh
 # OR
 source ~/.bash_profile  # For Bash
```

### **Install Other Dependencies:**
- You may need some additional dependencies for Flutter. You can install them using Hombrew. 
- Run the following commands:
    1. **usbmuxd**:
           * **Purpose**: usbmuxd is a daemon for communicating with iOS devices.
           * **Installation**: You can install it using Hombrew with the following command:
        ```bash
        brew install --HEAD usbmuxd
        ```
    2. **libimobiledevice**:
           * **Purpose**: libimobiledevice is a library for communicating with iOS devices. It's essential for Flutter when developing iOS applications.
           * **Installation**: You can install it using Hombrew with the following command:
        ```bash
        brew install --HEAD libimobiledevice
        ```
    3. **ideviceinstaller**:
           * **Purpose**: ideviceinstaller is a tool for installing, managing, and removing apps on iOS devices from the command line.
           * **Installation**: You can install it using Hombrew with the following command:
        ```bash
        brew install ideviceinstaller
        ```
    4. **ios-deploy**:
           * **Purpose**: ios-deploy is a command-line utility for deploying iOS apps to devices without using Xcode.
           * **Installation**: You can install it using Hombrew with the following command:
        ```bash
        brew install ios-deploy
        ```
    5. **CocoaPods**:
           * **Purpose**: CocoaPods is a dependency manager for Swift and Objective-C projects. It's used for managing dependencies in iOS projects.
           * **Installation**: You can install CocoaPods using RubyGems (a package manager for Ruby):
        ```bash
        sudo gem install cocoapods
        ```
    6. **Pod setup**:
       + **Purpose**: After installing CocoaPods, you need to set it up by running `pod setup`. This will create a local CocoaPods environment.
    + Make sure to install and set up these additional dependencies as needed, especially if you plan to develop Flutter apps for iOS, as these tools are essential for iOS development and device communication.
    
### **Install Xcode:**
- To develop Flutter apps, you'll need Xcode with the Command Line Tools installed. You can install Xcode from the Mac App Store.
- Additional things to run before starting the flutter app:
```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
sudo xcodebuild -license
```

### **Run `flutter doctor`:**
- To verify your Flutter installation and check for any missing dependencies, run the following command:
```bash
flutter doctor
```
- It will guide you through the installation of any missing components or warn you of any issues.

### **Set up an IDE:**
- You can use a code editor or an integrated development environment (IDE) like Visual Studio Code with the Flutter and Dart plugins for a smoother development experience.

Creating a Flutter app that connects to Back4App to manage tasks is a comprehensive task. Below is a general outline of the steps to follow to complete this assignment:

## **Assignment Steps:**

### **Step 1: Set Up Back4App**

- Sign up for a Back4App account (if not already exist).
- Create a new Back4App app named `**BITS Task Manager**`.
    + I have selected `**NoSQL**` Database for this, We can select any thing.
- In Back4App, create a class named `**Task**` with columns `**title**` (String) and `**description**` (String).

### **Step 2: Flutter Setup**

#### Install the Flutter plugin in Android Studio:
- Open **Android Studio**.
- Access **Preferences/Settings** (`Cmd + ,` on macOS).
- Go to **Plugins > Marketplace**.
- Search for `flutter` and select the `**Flutter**` plugin.
- Click Install, confirm the installation, and then Restart.

#### **Create a new Flutter project**
- Open the IDE- **Android Studio**.
- Select **New Flutter Project.**
- Choose **Flutter** and verify the SDK path.
- Enter a project name as `**bits_task_manager_app**`.
- Select **Application** as the project type.
- Click **Finish.**
- Wait for the project creation in Android Studio.

2. Open the `pubspec.yaml` file and add the required dependencies. we'll need to include the Parse SDK for Flutter, which allows us to interact with Back4App from your app. Add it to the dependencies section:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     parse_server_sdk: ^latest_version
   ```

3. Initializing the Parse SDK in your Flutter app. In your app's main Dart file, import the Parse library and initialize it with your Back4App keys. Here's a simplified example of how I did this:

   ```dart
   import 'package:flutter/material.dart';
   import 'package:parse_server_sdk/parse_server_sdk.dart';

   void main() async {
     await Parse().initialize(
       'YOUR_APP_ID',
       'YOUR_SERVER_URL',
       clientKey: 'YOUR_CLIENT_KEY',
       autoSendSessionId: true,
       debug: true,
     );

     runApp(MyApp());
   }
   ```

### **Step 3: Task List**

- Created a screen in the Flutter app to display a list of tasks. I used a `ListView` or any other widget that suits your design.
- Implemented a function to fetch tasks from Back4App using the Parse SDK. This function should query the "Task" class and retrieve the tasks.
- Display the tasks in the list view with titles and descriptions.

### **Step 4: Task Creation**

- Created a screen for adding new tasks. We can use a `TextFormField` to input the title and description.
- Implemented functionality to create and save tasks to Back4App using the Parse SDK. This involves creating a new instance of the "Task" class and saving it to the database.
- After a new task is created, verify that it appears in the task list by calling the fetch function and refreshing the UI.

### **Step 5: Task Details and Edit Page**

- Added a feature to view task details when a task is tapped in the task list. 
- We can navigate to a new screen and Edit the Details like or use a dialog to display the title and description of the selected task.
- After the task is edited, verify that it appears in the task list by calling the fetch function and refreshing the UI.

### **Step 6: Bonus Features**

- I have implemented additional features and enhancements such as:
    + Editing and updating existing tasks.
    + Task deletion functionality.
    + Task categorization or tags.
    + Due dates and reminders for tasks.
    

To run your Flutter app with different platforms (e.g., Android, iOS, and web), you can use the following Flutter commands. Make sure to navigate to your app's directory before running these commands. In my case, app's directory name is "bits_task_manager_app," navigate to that directory first.

1. **For Android**:
   - Connect your Android device or start an emulator.
   - Run your Flutter app on Android by using the following command:
     ```
     flutter run
     ```

2. **For iOS**:
   - Connect your iOS device or start the iOS simulator.
   - Run your Flutter app on iOS by using the following command:
     ```
     flutter run
     ```

3. **For Web**:
   - To run your Flutter app in a web browser, use the following command:
     ```
     flutter run -d web
     ```

4. **For Other Platforms**:
   - To see a list of available devices and platforms, you can use the following command:
     ```
     flutter devices
     ```

   - Then, choose the desired device or platform from the list and run your app using the `-d` flag. For example, to run on a specific Android device, use:
     ```
     flutter run -d <device_name>
     ```

   Replace `<device_name>` with the name of the specific device you want to run on.
       Ex: linux, windows, macos


Remember to ensure your Flutter environment is properly set up for each platform, and your app's dependencies are compatible with the selected platforms. Additionally, make sure you have the necessary tools and SDKs installed for Android and iOS development if you plan to target those platforms.

### **Submission**

- Host your Flutter app code on a GitHub repository.
- Create a README file with instructions on how to set up and run your app.
- In the README, provide a brief overview of any bonus features you've implemented (if any).



## References
- https://docs.flutter.dev/get-started/install/macos#android-setup
- https://www.freecodecamp.org/news/how-to-download-and-install-xcode/
- https://docs.flutter.dev/get-started/codelab

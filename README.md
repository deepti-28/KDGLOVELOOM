# Love Loom

## Overview

Love Loom is a Flutter-based dating app designed to help people form genuine connections through shared experiences and locations. Powered by a robust Node.js backend and MongoDB database, it delivers a smooth and engaging user experience across platforms, weaving together meaningful relationships beyond just swipes.

## App Flow & Features

### Splash Screen
- When the app opens, a splash screen appears with a prominent **"Find Your Connection"** button.
- Clicking on this button starts the user onboarding process.

### User Registration
- The first step is user registration with the following required details:
  - Name
  - Username
  - Password
  - Email
  - Date of Birth
  - Gender
- After successful registration, users must login using their **username and password**.

### Dashboard
Once logged in, the user sees the dashboard with the following features:

- **Location Display:**
  - The current location of the user is shown at the top of the dashboard.
  - Location permission must be enabled for this feature.
  
- **Add Notes (+ Button):**
  - Next to the location display, there is a plus (+) button.
  - Clicking this button allows the user to add personal notes.
  - Notes can be created, edited, and saved from here.

1. **Find a Match**
   - Clicking this option opens an interactive map view.
   - The initial location is centered on Vikaspuri.
   - Users can search locations (currently focused on Vikaspuri).
   - Location markers appear on the map representing other users.
   - Zooming in reveals bubbles showing users visually, with images or avatars.
   - Each bubble also indicates the number of messages sent by that user to the current user.
   - Clicking a user's bubble opens the chat interface.
   - Users can view the conversation thread and respond.
   - Users can accept or reject chat requests.
   - If both users choose a heart icon after chatting, it signifies a mutual match.
 2. **Explore**
   - Displays information and pictures of nearby cafes and places.
   - Clicking on a cafe opens its details page with options to:
   - Like the cafe
   - Comment on it
   - View cafe location on map
   - Add notes specific to that cafe via a pen icon leading to a note-taking page.
   - These notes help users create personalized experiences and connections around shared places.
    
- **Navigation:**
  - Home Page (Dashboard)
  - Compass symbol to access the map
  - Chat symbol to view chat requests and messages
  - Profile page

## Technology Stack

| Component      | Technology              |
| -------------- | ----------------------- |
| Frontend       | Flutter                 |
| Backend        | Node.js + WebSocket     |
| Database       | MongoDB                 |
| Authentication | Username & Password     |
| Location       | Device Geolocation      |

## Installation & Setup

### Prerequisites

- Flutter SDK (latest stable version)
- Node.js and npm installed
- MongoDB server 

### Steps

1. Clone the repository:
   ```
   git clone https://github.com/deepti-28/KDGLOVELOOM
   cd KDGLOVELOOM
   ```


2. Install frontend dependencies:
  ```
  flutter pub get
  ```

3. Setup backend and MongoDB
Make sure MongoDB server is running continuously by executing:
```
mongod
```
In another terminal, navigate to the backend folder and install dependencies including WebSocket:
```
npm install
npm install ws
```
Start the backend server:
```
npm start
```


4. Update frontend API endpoint URLs to point to your backend server in Flutter project config files.

5. Run the Flutter app:
   ```
   flutter run
   ```

## Usage

1. Launch the app. The splash screen with **"Find Your Connection"** appears.
2. Click the button to proceed to registration.
3. Fill in your details to register.
4. Login with your username and password.
5. After login, you reach the dashboard where you can:
- View your current location if enabled.
- Add notes by clicking the plus (+) button.
- Use **Find a Match** to search nearby users on the map and initiate chats.
- Explore cafes, interact by liking, commenting, and adding notes.
6. Use the bottom navigation bar to switch between Home, Map, Chat requests, and Profile.

## Future Improvements

- Real-time chat features with instant messaging and notifications.
- Wider location search beyond Vikaspuri.
- Social login options (Google, Facebook, etc.).
- Enhanced safety features and profile verification.
- Gamification elements to increase engagement.




Made with ❤️ using Flutter, Node.js,WebSocket and MongoDB.

# PumpkinApp-Interface
**PumpkinApp** is a mobile application designed to help users improve their English language skills. The app allows users to generate personalized quizzes based on video content they choose.
**PumpkinApp-Interface** depends on [PumpkinApp-Backend](https://github.com/leonorino/PumpkinApp-Backend). 

## Owerview
PumpkinApp empowers users with the following features:
1. **Video-based Learning**: Users can input a link to a YouTube video.
2. **Custom Quiz Generation**: Select the types of questions and the number of questions you want.
3. **Interactive Testing**: The app generates a quiz based on the video's transcript.
4. **Performance Tracking**: View detailed results after completing the quiz.\

This innovative approach integrates interactive testing with real-world video content, making learning English engaging and highly personalized.

## Project Structure
The core components of the project are organized as follows (located in the lib folder):
* `main.dart`: Entry point of the application, initializing and managing the app’s lifecycle.
* `result_screen.dart`: Responsible for displaying quiz results to the user.
* `second_screen.dart`: Handles navigation and interaction on the secondary screen.
* `top_bar.dart`: Contains the implementation for the top navigation bar or UI component.

## Getting started
To run the PumpkinApp Interface locally, follow these steps:
### Prerequisites
Ensure you have the following installed:
* [Flutter](https://flutter.dev/) (version >= 3.0)
* Dart SDK
### Installation
0. Ensure than PumpkinApp Backend is [running](https://github.com/leonorino/PumpkinApp-Backend/blob/main/README.md)
1. Clone the repository:
   ```
   git clone https://github.com/ellohar/PumpkinApp-Interface.git
   ```
3. Navigate to the project directory:
   ```
   cd PumpkinApp-Interface
   ```
5. Install dependencies:
   ```
   flutter pub get
   ```
7. Run the app on emulated device or in browser:
   ```
   flutter run
   ```

## Technologies Used
* **Flutter**: A powerful framework for building cross-platform mobile applications.
* **Dart**: A modern programming language optimized for UI development.

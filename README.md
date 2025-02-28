TestTask: User Registration and Listing Application  

Project Overview  
TestTask is an iOS application developed as a test assignment. It demonstrates the ability to handle POST/GET requests for fetching a list of users and registering new ones. The app uses MVVM architecture, coordinators for navigation, and SwiftUI for the UI.  

Technologies and Architecture  
- SwiftUI: For building the user interface.  
- MVVM: For separation of concerns and testability.  
- Coordinators: For managing navigation and flow between screens.  
- URLSession: For handling network requests.  
- Combine: For reactive data binding and state management.  

Project Setup  
Prerequisites  
- Xcode: Version 14 or higher.  
- iOS: Deployment target is iOS 16.0 or later.  
- Internet Connection: Required for API requests.  

Installation  
1. Clone the repository:  
   ```bash  
   git clone https://github.com/your-username/TestTask.git  
   ```  
2. Open the project in Xcode.  
3. Build and run the app (`Cmd + R`).  

Project Structure  

1. Model  
- User: Represents a user with properties like name, email, phone, and photo.  
- Position: Represents a job position.  

2. View  
- UserListView: Displays a paginated list of users.  
- SignUpView: Provides a form for user registration, including photo upload.  

3. ViewModel  
- UserListViewModel: Manages fetching and displaying the list of users.  
- SignUpViewModel: Handles user registration, data validation, and photo upload.  

4. Coordinators  
- MainCoordinator: The root coordinator that initializes the app flow.  
- UserListCoordinator: Handles navigation for the user list screen.  
- SignUpCoordinator: Manages the registration screen flow.  

5. Network  
- NetworkManager: Handles API requests (fetch users, register user, fetch token, fetch positions).  
- ImageServices: Manages saving and retrieving user photos.  
- ValidatorManager: Validates user input (name, email, phone).  
- NetworkMonitor: Tracks internet connectivity.  

Running the Project  
1. Ensure you have a stable internet connection.  
2. Launch the app on a simulator or physical device.  
3. Grant camera and photo library permissions when prompted.  

Special Configuration  
- Camera Access: Required for photo upload.  
- Token Management: Automatically handles token expiration.  

Potential Issues and Troubleshooting  

1. No Internet Connection  
- Solution: Ensure the device has an active internet connection.  

2. Camera Permissions Denied  
- Solution: Grant camera access in the device settings under **Privacy > Camera**.  

3. Token Expiration  
- Solution: The app automatically fetches a new token and retries the request.  

4. Server-Side Errors  
- Solution: Verify the input data and ensure it meets the server requirements.  

This README provides a concise guide to understanding, setting up, and running the TestTask application. For further details, refer to the inline comments and documentation within the source code.




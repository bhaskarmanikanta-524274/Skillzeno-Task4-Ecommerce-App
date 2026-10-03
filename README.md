# Skillzeno Task 4 - Complete E-Commerce Mobile App

Flutter e-commerce app for Skillzeno Flutter Developer Internship Task 4.

## Included requirements
- Login
- Signup
- Home/product catalogue
- Product details
- Cart with quantity management and total calculation
- Profile/logout
- REST API product data using Fake Store API
- Provider state management
- Loading and API error handling
- Responsive Material 3 UI
- Firebase Authentication hooks are included in the code (`firebase_auth` dependency and `AuthState.firebaseEnabled`).

## Run immediately
```powershell
flutter pub get
flutter run -d chrome
```
Demo login:
`demo@skillzeno.com` / `123456`

## Enable real Firebase Authentication
1. Create a Firebase project.
2. Enable Authentication > Email/Password.
3. Add your app and run `flutterfire configure`.
4. Change `AuthState.firebaseEnabled` in `lib/providers/app_state.dart` from `false` to `true`.
5. Run `flutter pub get` and `flutter run`.

The demo mode is included so the project can be tested and recorded before Firebase credentials are added.

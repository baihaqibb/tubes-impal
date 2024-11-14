/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_cal/home.dart'; // Pastikan untuk mengimpor home.dart

void main() {
  testWidgets('Login page displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: LoginPage(),
    ));

    // Verify that the login page displays the correct text.
    expect(find.text('SimpleCalendar :)'), findsOneWidget);
    expect(find.text('Log In to Continue'), findsOneWidget);
    expect(find.text('Please enter your username and password'), findsOneWidget);
    
    // Verify that the login button is present.
    expect(find.byType(ElevatedButton), findsOneWidget);
    
    // Verify that the text fields are present.
    expect(find.byType(TextFormField), findsNWidgets(2)); // Username and Password fields

    // Simulate user input and tap the login button.
    await tester.enterText(find.byType(TextFormField).first, 'testuser');
    await tester.enterText(find.byType(TextFormField).last, 'password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Rebuild the widget after the state has changed.

    // Add additional verifications as needed for your login logic.
  });
}
*/
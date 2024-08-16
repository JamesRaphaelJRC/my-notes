import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
// import 'package:mynotes/views/login_view.dart';
// import 'package:mynotes/views/register_view.dart';

void main() {
  // initialize flutter b4 anything else.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
          // the ops to carry out
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while Firebase initialization is in progress
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Show an error message if Firebase initialization fails
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.connectionState == ConnectionState.done) {
              // Firebase initialization succeeded
              final user = FirebaseAuth.instance.currentUser;
              if (user?.emailVerified ?? false) {
                print('verified');
              } else {
                print('verify your email first');
              }
              return const Center(child: Text('done'));
            }
            return const Center(child: Text('Unexpected state'));
          }),
    );
  }
}

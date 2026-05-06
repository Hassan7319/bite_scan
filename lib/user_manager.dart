import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String name;
  final String email;
  final String dob;
  final String gender;

  UserData({
    required this.name,
    required this.email,
    required this.dob,
    required this.gender,
  });
}

class UserManager {
  static final ValueNotifier<UserData?> currentUser = ValueNotifier<UserData?>(null);
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  static bool isFirebaseReady = false;
  static String? initializationError;

  static Future<void> register({
    required String name,
    required String email,
    required String password,
    required String dob,
    required String gender,
  }) async {
    if (!isFirebaseReady) throw Exception('Firebase not initialized: $initializationError');
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'dob': dob,
        'gender': gender,
        'createdAt': FieldValue.serverTimestamp(),
      });

      currentUser.value = UserData(
        name: name,
        email: email,
        dob: dob,
        gender: gender,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> login(String email, String password) async {
    if (!isFirebaseReady) throw Exception('Firebase not initialized: $initializationError');
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        currentUser.value = UserData(
          name: data['name'] ?? 'User',
          email: data['email'] ?? email,
          dob: data['dob'] ?? 'N/A',
          gender: data['gender'] ?? 'N/A',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> resetPassword(String email) async {
    if (!isFirebaseReady) throw Exception('Firebase not initialized: $initializationError');
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> logout() async {
    if (!isFirebaseReady) return;
    await _auth.signOut();
    currentUser.value = null;
  }
  
  static Future<void> initialize() async {
    if (!isFirebaseReady) return;
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          currentUser.value = UserData(
            name: data['name'] ?? 'User',
            email: data['email'] ?? firebaseUser.email!,
            dob: data['dob'] ?? 'N/A',
            gender: data['gender'] ?? 'N/A',
          );
        }
      } catch (e) {
        debugPrint('Error fetching user data: $e');
      }
    }
  }
}

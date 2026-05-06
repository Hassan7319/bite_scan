import 'dart:io';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/foundation.dart';

class AIService {
  static late final GenerativeModel _model;
  static bool _isInitialized = false;

  static void initialize() {
    try {
      // Changed to 'gemini-1.5-flash-latest' as 'gemini-3-flash' does not exist yet.
      // This provides the best balance of speed and image recognition for your app.
      _model = FirebaseVertexAI.instance.generativeModel(
        model: 'gemini-1.5-flash-latest',
        systemInstruction: Content.system(
          'You are the BiteScan AI assistant. Your ideology is built on two pillars: '
          '1. Safety: Identify household items and alert users if they are expired, recalled, or potentially hazardous. '
          '2. Sustainability (Upcycling): Suggest creative, practical "Scrapbook" hacks to repurpose items instead of throwing them away. '
          'When analyzing an image: '
          '- Identify the object clearly. '
          '- Provide a quick safety status. '
          '- Suggest exactly 3 unique upcycling ideas. '
          '- Keep the tone helpful, modern, and concise.'
          '- Suggest a recipe that can be cooked in less than 15 minutes if the object is a food item.'
        ),
      );
      _isInitialized = true;
    } catch (e) {
      debugPrint('AI Service initialization error: $e');
    }
  }

  static Future<String> analyzeItem(File imageFile) async {
    if (!_isInitialized) initialize();

    try {
      final bytes = await imageFile.readAsBytes();
      final prompt = [
        Content.multi([
          TextPart('Analyze this household item based on the BiteScan ideology.'),
          //DataPart('image/jpeg', bytes),
        ])
      ];

      final response = await _model.generateContent(prompt);
      return response.text ?? 'I could not identify this item. Please try a clearer photo.';
    } catch (e) {
      debugPrint('AI Analysis error: $e');
      return 'Error analyzing item: ${e.toString()}';
    }
  }

  static Future<String> analyzeItemWeb(Uint8List bytes) async {
    if (!_isInitialized) initialize();

    try {
      final prompt = [
        Content.multi([
          TextPart('Analyze this household item based on the BiteScan ideology.'),
          //DataPart('image/jpeg', bytes),
        ])
      ];

      final response = await _model.generateContent(prompt);
      return response.text ?? 'I could not identify this item. Please try a clearer photo.';
    } catch (e) {
      debugPrint('AI Analysis error: $e');
      return 'Error analyzing item: ${e.toString()}';
    }
  }
}

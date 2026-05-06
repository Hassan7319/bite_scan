import 'package:flutter/material.dart';

class ScrapbookItem {
  final String title;
  final String description;
  final DateTime date;

  ScrapbookItem({required this.title, required this.description, required this.date});
}

class DataManager {
  static final ValueNotifier<int> expiredCount = ValueNotifier(0);
  static final ValueNotifier<int> warningCount = ValueNotifier(0);
  static final ValueNotifier<int> safeCount = ValueNotifier(0);
  
  static final ValueNotifier<List<ScrapbookItem>> scrapbookItems = ValueNotifier([]);

  static void addItemResult({required String status, List<String>? ideas}) {
    if (status.toLowerCase().contains('safe')) {
      safeCount.value++;
    } else if (status.toLowerCase().contains('warning')) {
      warningCount.value++;
    } else if (status.toLowerCase().contains('expired')) {
      expiredCount.value++;
    }

    if (ideas != null) {
      for (var idea in ideas) {
        final parts = idea.split(':');
        final title = parts.length > 1 ? parts[0] : 'Upcycling Idea';
        final desc = parts.length > 1 ? parts.sublist(1).join(':') : idea;
        
        scrapbookItems.value = [
          ScrapbookItem(
            title: title.replaceAll(RegExp(r'^\d+\.\s*'), '').trim(), 
            description: desc.trim(), 
            date: DateTime.now()
          ),
          ...scrapbookItems.value,
        ];
      }
    }
  }
}

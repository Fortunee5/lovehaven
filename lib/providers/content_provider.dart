// lib/providers/content_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/content_model.dart';

class ContentProvider extends ChangeNotifier {
  List<ContentItem> _contentItems = [];
  final Uuid _uuid = Uuid();
  String _liveStreamUrl = '';

  List<ContentItem> get contentItems => _contentItems;
  String get liveStreamUrl => _liveStreamUrl;

  List<ContentItem> getContentByType(String type) {
    return _contentItems.where((item) => item.type == type).toList();
  }

  ContentProvider() {
    loadContent();
    _initializeDefaultContent();
  }

  void _initializeDefaultContent() {
    if (_contentItems.isEmpty) {
      // Add default content
      _contentItems = [
        ContentItem(
          id: _uuid.v4(),
          type: 'hero',
          title: 'Welcome to CELVZLOVEHAVEN',
          description: 'Join us for worship every Sunday',
          content: 'Experience God\'s love in a welcoming community',
          mediaUrl: 'https://picsum.photos/1920/1080?random=1',
        ),
        ContentItem(
          id: _uuid.v4(),
          type: 'sermon',
          title: 'Finding Hope in Difficult Times',
          description: 'Pastor John Smith',
          content: 'A powerful message about perseverance and faith',
          mediaUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
          date: DateTime.now().subtract(Duration(days: 7)),
        ),
        ContentItem(
          id: _uuid.v4(),
          type: 'event',
          title: 'Sunday Service',
          description: '9:00 AM & 11:00 AM',
          content: 'Join us for our weekly worship service',
          date: DateTime.now().add(Duration(days: 3)),
        ),
        ContentItem(
          id: _uuid.v4(),
          type: 'staff',
          title: 'Pastor John Smith',
          description: 'Senior Pastor',
          content: 'Pastor John has been serving our community for over 15 years.',
          mediaUrl: 'https://picsum.photos/400/400?random=2',
          metadata: {
            'email': 'pastor@celvzlovehaven.com',
            'phone': '555-0100',
          },
        ),
      ];
      saveContent();
    }
  }

  Future<void> loadContent() async {
    final prefs = await SharedPreferences.getInstance();
    final contentString = prefs.getString('content');
    _liveStreamUrl = prefs.getString('liveStreamUrl') ?? '';
    
    if (contentString != null) {
      final List<dynamic> contentJson = json.decode(contentString);
      _contentItems = contentJson.map((item) => ContentItem.fromJson(item)).toList();
    }
    notifyListeners();
  }

  Future<void> saveContent() async {
    final prefs = await SharedPreferences.getInstance();
    final contentString = json.encode(_contentItems.map((item) => item.toJson()).toList());
    await prefs.setString('content', contentString);
    await prefs.setString('liveStreamUrl', _liveStreamUrl);
  }

  void addContent(ContentItem item) {
    _contentItems.add(item);
    saveContent();
    notifyListeners();
  }

  void updateContent(String id, ContentItem newItem) {
    final index = _contentItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _contentItems[index] = newItem;
      saveContent();
      notifyListeners();
    }
  }

  void deleteContent(String id) {
    _contentItems.removeWhere((item) => item.id == id);
    saveContent();
    notifyListeners();
  }

  void setLiveStreamUrl(String url) {
    _liveStreamUrl = url;
    saveContent();
    notifyListeners();
  }

  String generateId() => _uuid.v4();
}
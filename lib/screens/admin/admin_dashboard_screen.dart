// lib/screens/admin/admin_dashboard_screen.dart - COMPLETE VERSION
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../../utils/web_file_picker.dart';
import '../../providers/auth_provider.dart';
import '../../providers/content_provider.dart';
import '../../models/content_model.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _selectedSection = 'hero';
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();
  final _mediaUrlController = TextEditingController();
  final _liveStreamController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedImageBase64;
  String? _selectedImageName;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkAuthStatus();
    if (!authProvider.isAuthenticated) {
      context.go('/admin-login');
    }
  }

  Future<void> _pickImage() async {
    try {
      final result = await WebFilePicker.pickImage();
      
      if (result != null) {
        setState(() {
          _selectedImageBase64 = result.base64;
          _selectedImageName = result.fileName;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image selected: $_selectedImageName')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final contentProvider = Provider.of<ContentProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    if (!authProvider.isAuthenticated) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
        leading: isMobile
            ? IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              )
            : null,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () => context.go('/'),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authProvider.logout();
              context.go('/');
            },
          ),
        ],
      ),
      drawer: isMobile ? _buildDrawer() : null,
      body: Row(
        children: [
          // Sidebar for desktop
          if (!isMobile)
            Container(
              width: 250,
              color: Colors.grey[100],
              child: _buildSidebarContent(),
            ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Manage ${_getTitle(_selectedSection)}',
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(
                        avatar: Icon(
                          _getSectionIcon(_selectedSection),
                          size: 16,
                          color: Colors.white,
                        ),
                        label: Text(
                          _selectedSection.toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  
                  if (_selectedSection == 'live') ...[
                    _buildLiveStreamManager(contentProvider),
                  ] else ...[
                    // Add New Content Form
                    Card(
                      elevation: 2,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 800),
                        child: Padding(
                          padding: EdgeInsets.all(isMobile ? 16 : 24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.add_circle,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Add New ${_getTitle(_selectedSection)}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(height: 30),
                                
                                // Title Field
                                TextFormField(
                                  controller: _titleController,
                                  decoration: InputDecoration(
                                    labelText: _selectedSection == 'testimony' ? 'Person Name' : 'Title',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.title),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a ${_selectedSection == 'testimony' ? 'name' : 'title'}';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                
                                // Description Field
                                if (_selectedSection != 'testimony')
                                  TextFormField(
                                    controller: _descriptionController,
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.description),
                                    ),
                                  ),
                                if (_selectedSection != 'testimony')
                                  SizedBox(height: 16),
                                
                                // Content Field
                                TextFormField(
                                  controller: _contentController,
                                  maxLines: _selectedSection == 'testimony' ? 5 : 4,
                                  decoration: InputDecoration(
                                    labelText: _selectedSection == 'testimony' ? 'Testimony' : 'Content',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(bottom: 60),
                                      child: Icon(Icons.article),
                                    ),
                                    helperText: _selectedSection == 'testimony' 
                                        ? 'Enter the testimony text' 
                                        : null,
                                  ),
                                ),
                                SizedBox(height: 16),
                                
                                // Media Input Based on Section Type
                                if (_selectedSection == 'sermon') ...[
                                  TextFormField(
                                    controller: _mediaUrlController,
                                    decoration: InputDecoration(
                                      labelText: 'YouTube URL',
                                      border: OutlineInputBorder(),
                                      helperText: 'Enter YouTube video URL for sermon',
                                      prefixIcon: Icon(Icons.video_library),
                                    ),
                                  ),
                                ] else if (_selectedSection == 'testimony') ...[
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.person_pin, color: Theme.of(context).primaryColor),
                                            SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Testimony Photo',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    _selectedImageName ?? 'No photo selected',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            ElevatedButton.icon(
                                              onPressed: _pickImage,
                                              icon: Icon(Icons.upload_file, color: Colors.white),
                                              label: Text('Select Photo', style: TextStyle(color: Colors.white)),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (_selectedImageBase64 != null) ...[
                                          SizedBox(height: 16),
                                          Container(
                                            height: 120,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Theme.of(context).primaryColor,
                                                width: 3,
                                              ),
                                              image: DecorationImage(
                                                image: MemoryImage(
                                                  base64Decode(_selectedImageBase64!),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ] else if (_selectedSection == 'hero' || 
                                          _selectedSection == 'staff' || 
                                          _selectedSection == 'visit') ...[
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.image, color: Theme.of(context).primaryColor),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            _selectedImageName ?? 'No image selected',
                                            style: TextStyle(fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        ElevatedButton.icon(
                                          onPressed: _pickImage,
                                          icon: Icon(Icons.upload_file, color: Colors.white),
                                          label: Text('Select Image', style: TextStyle(color: Colors.white)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_selectedImageBase64 != null) ...[
                                    SizedBox(height: 16),
                                    Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: MemoryImage(
                                            base64Decode(_selectedImageBase64!),
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                                
                                // Staff specific fields
                                if (_selectedSection == 'staff') ...[
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.email),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _phoneController,
                                          decoration: InputDecoration(
                                            labelText: 'Phone',
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.phone),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                
                                // Event Date Picker
                                if (_selectedSection == 'event') ...[
                                  SizedBox(height: 16),
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            _selectedDate != null 
                                              ? 'Event Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                              : 'No date selected',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        TextButton.icon(
                                          onPressed: () async {
                                            final date = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime.now().add(Duration(days: 365)),
                                            );
                                            setState(() {
                                              _selectedDate = date;
                                            });
                                          },
                                          icon: Icon(Icons.edit_calendar),
                                          label: Text('Select Date'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                
                                SizedBox(height: 24),
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: _addContent,
                                      icon: Icon(Icons.add, color: Colors.white),
                                      label: Text('Add Content', style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    TextButton.icon(
                                      onPressed: _clearForm,
                                      icon: Icon(Icons.clear),
                                      label: Text('Clear Form'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // Content List
                    Card(
                      elevation: 2,
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 600),
                        child: Padding(
                          padding: EdgeInsets.all(isMobile ? 16 : 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.list_alt,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Existing Content',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${contentProvider.getContentByType(_selectedSection).length} items',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(height: 30),
                              Expanded(
                                child: contentProvider.getContentByType(_selectedSection).isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.folder_open,
                                              size: 64,
                                              color: Colors.grey.shade400,
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'No content yet',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Add your first ${_getTitle(_selectedSection).toLowerCase()}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: contentProvider.getContentByType(_selectedSection).length,
                                        itemBuilder: (context, index) {
                                          final item = contentProvider.getContentByType(_selectedSection)[index];
                                          return _buildContentItem(item);
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentItem(ContentItem item) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _buildItemLeading(item),
        title: Text(
          item.title,
          style: TextStyle(fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: item.description != null
            ? Text(
                item.description!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            : item.content != null
                ? Text(
                    item.content!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.date != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${item.date!.day}/${item.date!.month}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _deleteContent(item.id),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.grey[100],
        child: _buildSidebarContent(),
      ),
    );
  }

  Widget _buildSidebarContent() {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          color: Theme.of(context).primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.dashboard,
                color: Colors.white,
                size: 32,
              ),
              SizedBox(height: 12),
              Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        _buildSidebarItem('Hero Section', 'hero', Icons.image),
        _buildSidebarItem('Sermons', 'sermon', Icons.video_library),
        _buildSidebarItem('Events', 'event', Icons.event),
        _buildSidebarItem('Staff', 'staff', Icons.people),
        _buildSidebarItem('Testimonies', 'testimony', Icons.format_quote),
        _buildSidebarItem('Live Stream', 'live', Icons.live_tv),
        _buildSidebarItem('About Content', 'about', Icons.info),
        _buildSidebarItem('Visit Info', 'visit', Icons.location_on),
      ],
    );
  }

  Widget _buildItemLeading(ContentItem item) {
    if (_selectedSection == 'testimony' && item.mediaUrl != null && item.mediaUrl!.startsWith('data:image')) {
      // Testimony with circular image
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          image: DecorationImage(
            image: MemoryImage(
              base64Decode(item.mediaUrl!.split(',').last),
            ),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (item.mediaUrl != null && item.mediaUrl!.startsWith('data:image')) {
      // Regular image
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: MemoryImage(
              base64Decode(item.mediaUrl!.split(',').last),
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      );
    } else if (item.type == 'sermon') {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(Icons.play_circle_outline, color: Theme.of(context).primaryColor),
      );
    } else if (item.type == 'testimony') {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.person, color: Theme.of(context).primaryColor),
      );
    }
    
    // Default icon based on type
    IconData iconData = _getSectionIcon(item.type);
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(iconData, color: Theme.of(context).primaryColor),
    );
  }

  IconData _getSectionIcon(String section) {
    switch (section) {
      case 'hero':
        return Icons.image;
      case 'sermon':
        return Icons.video_library;
      case 'event':
        return Icons.event;
      case 'staff':
        return Icons.person;
      case 'testimony':
        return Icons.format_quote;
      case 'live':
        return Icons.live_tv;
      case 'about':
        return Icons.info;
      case 'visit':
        return Icons.location_on;
      default:
        return Icons.article;
    }
  }

  Widget _buildSidebarItem(String title, String section, IconData icon) {
    final isSelected = _selectedSection == section;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
      onTap: () {
        setState(() {
          _selectedSection = section;
          _clearForm();
        });
        if (MediaQuery.of(context).size.width < 768) {
          Navigator.pop(context); // Close drawer on mobile
        }
      },
    );
  }

  Widget _buildLiveStreamManager(ContentProvider contentProvider) {
    _liveStreamController.text = contentProvider.liveStreamUrl;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.live_tv,
                  color: Colors.red,
                  size: 28,
                ),
                SizedBox(width: 12),
                Text(
                  'Live Stream Settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(height: 30),
            TextFormField(
              controller: _liveStreamController,
              decoration: InputDecoration(
                labelText: 'YouTube Live Stream URL',
                border: OutlineInputBorder(),
                helperText: 'Enter the YouTube live stream URL or video ID',
                prefixIcon: Icon(Icons.link),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    contentProvider.setLiveStreamUrl(_liveStreamController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Live stream URL updated'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: Icon(Icons.save, color: Colors.white),
                  label: Text('Save', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    _liveStreamController.clear();
                    contentProvider.setLiveStreamUrl('');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Live stream URL cleared'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  icon: Icon(Icons.clear, color: Colors.red),
                  label: Text('Clear', style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
            if (_liveStreamController.text.isNotEmpty) ...[
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Live stream is configured: ${_liveStreamController.text}',
                        style: TextStyle(color: Colors.green[700], fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _contentController.clear();
    _mediaUrlController.clear();
    _emailController.clear();
    _phoneController.clear();
    _selectedDate = null;
    _selectedImageBase64 = null;
    _selectedImageName = null;
    setState(() {});
  }

  void _addContent() {
    if (_formKey.currentState!.validate()) {
      final contentProvider = Provider.of<ContentProvider>(context, listen: false);
      
      String? mediaUrl;
      if (_selectedSection == 'sermon') {
        mediaUrl = _mediaUrlController.text.isNotEmpty ? _mediaUrlController.text : null;
      } else if (_selectedImageBase64 != null && 
                 (_selectedSection == 'hero' || 
                  _selectedSection == 'staff' || 
                  _selectedSection == 'visit' ||
                  _selectedSection == 'testimony')) {
        mediaUrl = 'data:image/png;base64,$_selectedImageBase64';
      }
      
      Map<String, dynamic>? metadata;
      if (_selectedSection == 'staff') {
        metadata = {
          if (_emailController.text.isNotEmpty) 'email': _emailController.text,
          if (_phoneController.text.isNotEmpty) 'phone': _phoneController.text,
        };
      }
      
      final newContent = ContentItem(
        id: contentProvider.generateId(),
        type: _selectedSection,
        title: _titleController.text,
        description: _selectedSection != 'testimony' && _descriptionController.text.isNotEmpty 
            ? _descriptionController.text 
            : null,
        content: _contentController.text.isNotEmpty ? _contentController.text : null,
        mediaUrl: mediaUrl,
        date: _selectedDate,
        metadata: metadata,
      );
      
      contentProvider.addContent(newContent);
      _clearForm();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_getTitle(_selectedSection)} added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _deleteContent(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Delete Content'),
          ],
        ),
        content: Text('Are you sure you want to delete this content? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final contentProvider = Provider.of<ContentProvider>(context, listen: false);
              contentProvider.deleteContent(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Content deleted successfully'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _getTitle(String section) {
    switch (section) {
      case 'hero':
        return 'Hero Section';
      case 'sermon':
        return 'Sermons';
      case 'event':
        return 'Events';
      case 'staff':
        return 'Staff Members';
      case 'testimony':
        return 'Testimonies';
      case 'live':
        return 'Live Stream';
      case 'about':
        return 'About Content';
      case 'visit':
        return 'Visit Information';
      default:
        return 'Content';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _mediaUrlController.dispose();
    _liveStreamController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
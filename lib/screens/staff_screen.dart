// lib/screens/staff_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../providers/content_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';

class StaffScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);
    final staff = contentProvider.getContentByType('staff');

    return Scaffold(
      body: Column(
        children: [
          AppHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Staff & Leaders',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Meet our dedicated team',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Leadership Team
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'Pastoral Staff',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          constraints: BoxConstraints(maxWidth: 1200),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 
                                             MediaQuery.of(context).size.width > 600 ? 2 : 1,
                              crossAxisSpacing: 30,
                              mainAxisSpacing: 30,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: staff.length,
                            itemBuilder: (context, index) => _buildStaffCard(staff[index], context),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Ministry Leaders
                  Container(
                    color: Colors.grey[50],
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'Ministry Leaders',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          constraints: BoxConstraints(maxWidth: 1000),
                          child: Column(
                            children: [
                              _buildMinistryLeader('Worship Ministry', 'Sarah Johnson', 'worship@celvzlovehaven.com', context),
                              _buildMinistryLeader('Youth Ministry', 'Mike Thompson', 'youth@celvzlovehaven.com', context),
                              _buildMinistryLeader('Children\'s Ministry', 'Lisa Anderson', 'kids@celvzlovehaven.com', context),
                              _buildMinistryLeader('Outreach Ministry', 'David Wilson', 'outreach@celvzlovehaven.com', context),
                              _buildMinistryLeader('Small Groups', 'Jennifer Brown', 'groups@celvzlovehaven.com', context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Contact Section
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'Get In Touch',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Our staff is here to serve you and answer any questions you may have.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildContactCard(
                              Icons.phone,
                              'Call Us',
                              '(555) 123-4567',
                              context,
                            ),
                            SizedBox(width: 40),
                            _buildContactCard(
                              Icons.email,
                              'Email Us',
                              'info@celvzlovehaven.com',
                              context,
                            ),
                            SizedBox(width: 40),
                            _buildContactCard(
                              Icons.access_time,
                              'Office Hours',
                              'Mon-Fri 9AM-5PM',
                              context,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  AppFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffCard(dynamic staff, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            child: staff.mediaUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      staff.mediaUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    staff.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (staff.description != null) ...[
                    SizedBox(height: 8),
                    Text(
                      staff.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (staff.content != null) ...[
                    SizedBox(height: 12),
                    Text(
                      staff.content,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (staff.metadata != null) ...[
                    SizedBox(height: 16),
                    if (staff.metadata['email'] != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 5),
                          Text(
                            staff.metadata['email'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
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

  Widget _buildMinistryLeader(String ministry, String name, String email, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(20),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            Icons.person,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
        ),
        title: Text(
          ministry,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(name, style: TextStyle(fontSize: 16)),
            Text(email, style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String subtitle, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
// lib/screens/about_screen.dart - FIXED OVERFLOW VERSION
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/content_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);
    final aboutContent = contentProvider.getContentByType('about');
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1200;

    return Scaffold(
      body: Column(
        children: [
          AppHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Hero Section
                  Container(
                    height: 400,
                    width: double.infinity,
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
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'About Us',
                              style: TextStyle(
                                fontSize: isMobile ? 36 : 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ).animate().fadeIn().slideY(),
                            SizedBox(height: 20),
                            Text(
                              'Our Story, Mission & Values',
                              style: TextStyle(
                                fontSize: isMobile ? 20 : 24,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              textAlign: TextAlign.center,
                            ).animate().fadeIn(delay: 300.milliseconds),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Mission Section
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'Our Mission',
                          style: TextStyle(
                            fontSize: isMobile ? 28 : 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          constraints: BoxConstraints(maxWidth: 800),
                          child: Text(
                            aboutContent.isNotEmpty && aboutContent[0].content != null
                                ? aboutContent[0].content!
                                : 'To reach people with the life-giving message of Jesus Christ so that they may experience God\'s love, forgiveness, and purpose for their lives.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: isMobile ? 16 : 18, height: 1.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Core Values - Made Responsive
                  Container(
                    color: Colors.grey[50],
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'Our Core Values',
                          style: TextStyle(
                            fontSize: isMobile ? 28 : 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          constraints: BoxConstraints(maxWidth: 1200),
                          child: Wrap(
                            spacing: 30,
                            runSpacing: 30,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildValueCard(
                                'Love',
                                'We love God and love people unconditionally',
                                Icons.favorite,
                                context,
                                isMobile: isMobile,
                              ),
                              _buildValueCard(
                                'Faith',
                                'We believe in the power of faith to transform lives',
                                Icons.light,
                                context,
                                isMobile: isMobile,
                              ),
                              _buildValueCard(
                                'Community',
                                'We build authentic relationships and do life together',
                                Icons.people,
                                context,
                                isMobile: isMobile,
                              ),
                              _buildValueCard(
                                'Service',
                                'We serve our community with compassion and excellence',
                                Icons.handshake,
                                context,
                                isMobile: isMobile,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Beliefs Section
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'What We Believe',
                          style: TextStyle(
                            fontSize: isMobile ? 28 : 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          constraints: BoxConstraints(maxWidth: 800),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBeliefItem('The Bible is God\'s Word to us', context),
                              _buildBeliefItem('There is one God, eternally existing in three persons', context),
                              _buildBeliefItem('Jesus Christ is God\'s son and our Savior', context),
                              _buildBeliefItem('Salvation is by grace through faith', context),
                              _buildBeliefItem('The Church is the body of Christ', context),
                              _buildBeliefItem('Jesus will return again', context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // History Section
                  Container(
                    color: Colors.grey[50],
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'Our History',
                          style: TextStyle(
                            fontSize: isMobile ? 28 : 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          constraints: BoxConstraints(maxWidth: 800),
                          child: Text(
                            'Founded in 1985, CELVZLOVEHAVEN has been serving our community for nearly four decades. What started as a small gathering of believers has grown into a vibrant church family of over 2,000 members.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: isMobile ? 14 : 16, height: 1.6),
                          ),
                        ),
                        SizedBox(height: 40),
                        // Timeline - Made Responsive
                        Container(
                          constraints: BoxConstraints(maxWidth: 1000),
                          child: Column(
                            children: [
                              _buildTimelineItem('1985', 'Church Founded', 'Started with 25 members', context, isMobile),
                              _buildTimelineItem('1992', 'First Building', 'Moved to our first location', context, isMobile),
                              _buildTimelineItem('2005', 'Community Outreach', 'Launched programs', context, isMobile),
                              _buildTimelineItem('2015', 'Current Campus', 'Opened worship center', context, isMobile),
                              _buildTimelineItem('2025', 'Digital Ministry', 'Expanded online', context, isMobile),
                            ],
                          ),
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

  Widget _buildValueCard(String title, String description, IconData icon, BuildContext context, {bool isMobile = false}) {
    return Container(
      width: isMobile ? MediaQuery.of(context).size.width - 40 : 250,
      constraints: BoxConstraints(maxWidth: 250),
      padding: EdgeInsets.all(20),
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
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildBeliefItem(String text, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String year, String title, String description, BuildContext context, bool isMobile) {
    if (isMobile) {
      return Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      year,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
            width: 100,
            child: Text(
              year,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
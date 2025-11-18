// lib/screens/visit_screen.dart - FIXED RESPONSIVE SECTION
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/content_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';

class VisitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);
    final visitInfo = contentProvider.getContentByType('visit');
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

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
                              'Plan Your Visit',
                              style: TextStyle(
                                fontSize: isMobile ? 32 : 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'We can\'t wait to meet you!',
                              style: TextStyle(
                                fontSize: isMobile ? 20 : 24,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Theme.of(context).primaryColor,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 24 : 40,
                                  vertical: 16,
                                ),
                              ),
                              child: Text(
                                'I\'M NEW HERE',
                                style: TextStyle(
                                  fontSize: isMobile ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Service Times - Made Responsive
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'Service Times',
                          style: TextStyle(
                            fontSize: isMobile ? 28 : 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 40),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildServiceTimeCard(
                              'Sunday Services',
                              ['9:00 AM - Traditional', '11:00 AM - Contemporary'],
                              Icons.wb_sunny,
                              context,
                              isMobile: isMobile,
                            ),
                            _buildServiceTimeCard(
                              'Wednesday Night',
                              ['7:00 PM - Bible Study'],
                              Icons.menu_book,
                              context,
                              isMobile: isMobile,
                            ),
                            _buildServiceTimeCard(
                              'Online Service',
                              ['Live Stream Available'],
                              Icons.laptop,
                              context,
                              isMobile: isMobile,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // What to Expect - Made Responsive
                  Container(
                    color: Colors.grey[50],
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'What to Expect',
                          style: TextStyle(
                            fontSize: isMobile ? 28 : 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          constraints: BoxConstraints(maxWidth: 1000),
                          child: Wrap(
                            spacing: 30,
                            runSpacing: 30,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildExpectCard(
                                'Friendly Welcome',
                                'Our greeting team will welcome you at the door and help you find your way.',
                                FontAwesomeIcons.handshake,
                                context,
                                isMobile: isMobile,
                              ),
                              _buildExpectCard(
                                'Casual Atmosphere',
                                'Come as you are! We have a relaxed, welcoming environment.',
                                FontAwesomeIcons.userGroup,
                                context,
                                isMobile: isMobile,
                              ),
                              _buildExpectCard(
                                'Kids Programs',
                                'Safe and fun programs for children of all ages during service.',
                                FontAwesomeIcons.children,
                                context,
                                isMobile: isMobile,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          constraints: BoxConstraints(maxWidth: 800),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            visitInfo.isNotEmpty && visitInfo[0].content != null
                                ? visitInfo[0].content!
                                : 'Our services typically last about 75 minutes and include contemporary worship music and practical, Bible-based teaching. We have programs for kids from nursery through 5th grade, and our youth meet separately during the 11:00 AM service.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, height: 1.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Location & Directions - Made Responsive
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'Location & Directions',
                          style: TextStyle(
                            fontSize: isMobile ? 28 : 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          constraints: BoxConstraints(maxWidth: 1000),
                          child: isMobile
                              ? Column(
                                  children: [
                                    Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        height: 300,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.map,
                                                size: 60,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                'Interactive Map',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    _buildAddressSection(context),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Container(
                                          height: 400,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.map,
                                                  size: 80,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                                SizedBox(height: 20),
                                                Text(
                                                  'Interactive Map',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    Expanded(
                                      child: _buildAddressSection(context),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),

                  // Connect Card
                  Container(
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'Let Us Know You\'re Coming',
                          style: TextStyle(
                            fontSize: isMobile ? 24 : 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Fill out a connect card and we\'ll save you a seat!',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40),
                        Container(
                          constraints: BoxConstraints(maxWidth: 600),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(isMobile ? 20 : 30),
                              child: Column(
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Name',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Phone (Optional)',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Service Time',
                                      border: OutlineInputBorder(),
                                    ),
                                    items: [
                                      DropdownMenuItem(value: '9am', child: Text('Sunday 9:00 AM')),
                                      DropdownMenuItem(value: '11am', child: Text('Sunday 11:00 AM')),
                                      DropdownMenuItem(value: 'wed', child: Text('Wednesday 7:00 PM')),
                                    ],
                                    onChanged: (value) {},
                                  ),
                                  SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 32 : 48,
                                        vertical: 16,
                                      ),
                                    ),
                                    child: Text('SUBMIT', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
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

  Widget _buildAddressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Address',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        _buildAddressItem(Icons.location_on, '123 Church Street', context),
        _buildAddressItem(Icons.location_city, 'City, State 12345', context),
        _buildAddressItem(Icons.phone, '(555) 123-4567', context),
        _buildAddressItem(Icons.email, 'info@celvzlovehaven.com', context),
        SizedBox(height: 30),
        Text(
          'Parking',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Free parking is available in our main lot. Additional parking is available on surrounding streets.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildServiceTimeCard(String title, List<String> times, IconData icon, BuildContext context, {bool isMobile = false}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: isMobile ? double.infinity : 300,
        constraints: BoxConstraints(maxWidth: 300),
        padding: EdgeInsets.all(isMobile ? 20 : 30),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: isMobile ? 18 : 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            ...times.map((time) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                time,
                style: TextStyle(fontSize: isMobile ? 14 : 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildExpectCard(String title, String description, IconData icon, BuildContext context, {bool isMobile = false}) {
    return Container(
      width: isMobile ? double.infinity : 280,
      constraints: BoxConstraints(maxWidth: 280),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: FaIcon(
              icon,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: isMobile ? 18 : 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressItem(IconData icon, String text, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
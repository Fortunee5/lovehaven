// lib/screens/next_steps_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/content_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';

class NextStepsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Next Steps',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Your journey of faith starts here',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Steps Section
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'Take Your Next Step',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'No matter where you are in your spiritual journey, we have a next step for you.',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 60),
                        Container(
                          constraints: BoxConstraints(maxWidth: 1200),
                          child: Column(
                            children: [
                              _buildStepCard(
                                '01',
                                'Attend a Service',
                                'Join us for worship any Sunday morning or Wednesday evening. Experience our community and hear God\'s word.',
                                Icons.church,
                                context,
                              ),
                              SizedBox(height: 30),
                              _buildStepCard(
                                '02',
                                'Join a Small Group',
                                'Connect with others in a smaller setting. Build relationships and grow in your faith together.',
                                Icons.group,
                                context,
                                isReverse: true,
                              ),
                              SizedBox(height: 30),
                              _buildStepCard(
                                '03',
                                'Discover Your Purpose',
                                'Take our spiritual gifts assessment and find your unique place to serve in our church family.',
                                Icons.explore,
                                context,
                              ),
                              SizedBox(height: 30),
                              _buildStepCard(
                                '04',
                                'Get Baptized',
                                'Take the public step of faith through baptism. We offer baptism classes and celebrations regularly.',
                                FontAwesomeIcons.water,
                                context,
                                isReverse: true,
                              ),
                              SizedBox(height: 30),
                              _buildStepCard(
                                '05',
                                'Serve Others',
                                'Use your gifts to make a difference. Join one of our ministry teams and impact lives.',
                                Icons.volunteer_activism,
                                context,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Growth Track
                  Container(
                    color: Colors.grey[50],
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'Growth Track',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          constraints: BoxConstraints(maxWidth: 1000),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildGrowthTrackCard(
                                'Step 1',
                                'Discover CELVZLOVEHAVEN',
                                'Learn about our church\'s mission, values, and beliefs',
                                context,
                              ),
                              _buildGrowthTrackCard(
                                'Step 2',
                                'Discover Your Design',
                                'Explore your personality, gifts, and purpose',
                                context,
                              ),
                              _buildGrowthTrackCard(
                                'Step 3',
                                'Discover Your Ministry',
                                'Find your place to serve and make a difference',
                                context,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                          ),
                          child: Text('REGISTER FOR GROWTH TRACK'),
                        ),
                      ],
                    ),
                  ),

                  // Ministries
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'Get Connected',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          constraints: BoxConstraints(maxWidth: 1200),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 1.2,
                            children: [
                              _buildMinistryCard('Kids Ministry', FontAwesomeIcons.children, context),
                              _buildMinistryCard('Youth Ministry', FontAwesomeIcons.userGraduate, context),
                              _buildMinistryCard('Worship Team', FontAwesomeIcons.music, context),
                              _buildMinistryCard('Small Groups', FontAwesomeIcons.peopleGroup, context),
                              _buildMinistryCard('Men\'s Ministry', FontAwesomeIcons.personChalkboard, context),
                              _buildMinistryCard('Women\'s Ministry', FontAwesomeIcons.personDress, context),
                              _buildMinistryCard('Outreach', FontAwesomeIcons.handsHelping, context),
                              _buildMinistryCard('Prayer Team', FontAwesomeIcons.handsPraying, context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Call to Action
                  Container(
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'Ready to Take Your Next Step?',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'We\'re here to help you grow in your faith journey.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Theme.of(context).primaryColor,
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              ),
                              child: Text('CONTACT US'),
                            ),
                            SizedBox(width: 20),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Colors.white, width: 2),
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              ),
                              child: Text('LEARN MORE'),
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

  Widget _buildStepCard(String number, String title, String description, IconData icon, BuildContext context, {bool isReverse = false}) {
    final content = [
      Expanded(
        child: Container(
          padding: EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: isReverse ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                number,
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey[600],
                ),
                textAlign: isReverse ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),
      ),
      Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: icon is IconData
              ? Icon(icon, size: 80, color: Theme.of(context).primaryColor)
              : FaIcon(icon as IconData, size: 80, color: Theme.of(context).primaryColor),
        ),
      ),
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: isReverse ? content.reversed.toList() : content,
        ),
      ),
    );
  }

  Widget _buildGrowthTrackCard(String step, String title, String description, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 300,
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                step,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinistryCard(String title, IconData icon, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// lib/widgets/app_footer.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      color: Color(0xFF1a1a1a),
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          if (!isMobile)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FooterColumn(
                  title: 'Connect',
                  items: [
                    _FooterItem('Facebook', () => _launchUrl('https://facebook.com')),
                    _FooterItem('Instagram', () => _launchUrl('https://instagram.com')),
                    _FooterItem('YouTube', () => _launchUrl('https://youtube.com')),
                    _FooterItem('Twitter', () => _launchUrl('https://twitter.com')),
                  ],
                ),
                _FooterColumn(
                  title: 'Quick Links',
                  items: [
                    _FooterItem('About Us', () => context.go('/about')),
                    _FooterItem('Sermons', () => context.go('/sermons')),
                    _FooterItem('Events', () => context.go('/calendar')),
                    _FooterItem('Give Online', () {}),
                  ],
                ),
                _FooterColumn(
                  title: 'Contact',
                  items: [
                    _FooterItem('123 Church Street', () {}),
                    _FooterItem('City, State 12345', () {}),
                    _FooterItem('(555) 123-4567', () => _launchUrl('tel:5551234567')),
                    _FooterItem('info@celvzlovehaven.com', () => _launchUrl('mailto:info@celvzlovehaven.com')),
                  ],
                ),
                _FooterColumn(
                  title: 'Service Times',
                  items: [
                    _FooterItem('Sunday: 9:00 AM', () {}),
                    _FooterItem('Sunday: 11:00 AM', () {}),
                    _FooterItem('Wednesday: 7:00 PM', () {}),
                    _FooterItem('Online: 24/7', () => context.go('/live')),
                  ],
                ),
              ],
            )
          else
            Column(
              children: [
                _FooterColumn(
                  title: 'Connect',
                  items: [
                    _FooterItem('Social Media', () {}),
                  ],
                ),
                SizedBox(height: 20),
                _FooterColumn(
                  title: 'Contact',
                  items: [
                    _FooterItem('(555) 123-4567', () => _launchUrl('tel:5551234567')),
                    _FooterItem('info@celvzlovehaven.com', () => _launchUrl('mailto:info@celvzlovehaven.com')),
                  ],
                ),
              ],
            ),
          Divider(color: Colors.grey[700], height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => context.go('/admin-login'),
                child: Text(
                  '© Copyright 2025 CELVZLOVEHAVEN. All rights reserved.',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<_FooterItem> items;

  const _FooterColumn({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...items.map((item) => Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: InkWell(
            onTap: item.onTap,
            child: Text(
              item.text,
              style: TextStyle(color: Colors.grey[300], fontSize: 14),
            ),
          ),
        )),
      ],
    );
  }
}

class _FooterItem {
  final String text;
  final VoidCallback onTap;

  _FooterItem(this.text, this.onTap);
}
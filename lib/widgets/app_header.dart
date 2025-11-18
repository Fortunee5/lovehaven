// lib/widgets/app_header.dart - FIXED RESPONSIVE VERSION
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool isScrolled;

  const AppHeader({Key? key, this.isScrolled = false}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    final isDesktopSmall = screenWidth >= 1024 && screenWidth < 1400;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isScrolled ? Colors.white : Colors.white.withOpacity(0.95),
        boxShadow: isScrolled
            ? [BoxShadow(color: Colors.black12, blurRadius: 10)]
            : [],
      ),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 20),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo - Responsive sizing
              GestureDetector(
                onTap: () => context.go('/'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FontAwesomeIcons.church,
                      color: Theme.of(context).primaryColor,
                      size: isMobile ? 24 : (isTablet ? 28 : 32),
                    ),
                    SizedBox(width: isMobile ? 8 : 12),
                    Text(
                      isMobile ? 'CLH' : (isTablet ? 'CELVZ' : 'CELVZLOVEHAVEN'),
                      style: TextStyle(
                        fontSize: isMobile ? 20 : (isTablet ? 22 : 24),
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Navigation - Responsive for all screen sizes
              if (isMobile) ...[
                IconButton(
                  icon: Icon(Icons.menu, color: Theme.of(context).primaryColor),
                  onPressed: () => _showMobileMenu(context),
                ),
              ] else if (isTablet) ...[
                Row(
                  children: [
                    _NavItem(title: 'Home', path: '/', isCompact: true),
                    _NavItem(title: 'Visit', path: '/visit', isCompact: true),
                    _NavItem(title: 'Sermons', path: '/sermons', isCompact: true),
                    _NavItem(title: 'Live', path: '/live', isLive: true, isCompact: true),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Theme.of(context).primaryColor),
                      onSelected: (value) => context.go(value),
                      itemBuilder: (context) => [
                        PopupMenuItem(value: '/about', child: Text('About Us')),
                        PopupMenuItem(value: '/calendar', child: Text('Calendar')),
                        PopupMenuItem(value: '/staff', child: Text('Staff')),
                        PopupMenuItem(value: '/next-steps', child: Text('Next Steps')),
                      ],
                    ),
                  ],
                ),
              ] else if (isDesktopSmall) ...[
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _NavItem(title: 'Home', path: '/', isCompact: true),
                      _NavItem(title: 'Visit', path: '/visit', isCompact: true),
                      _NavItem(title: 'About', path: '/about', isCompact: true),
                      _NavItem(title: 'Sermons', path: '/sermons', isCompact: true),
                      _NavItem(title: 'Calendar', path: '/calendar', isCompact: true),
                      _NavItem(title: 'Staff', path: '/staff', isCompact: true),
                      _NavItem(title: 'Next Steps', path: '/next-steps', isCompact: true),
                      _NavItem(title: 'Live', path: '/live', isLive: true, isCompact: true),
                    ],
                  ),
                ),
              ] else ...[
                Row(
                  children: [
                    _NavItem(title: 'Home', path: '/'),
                    _NavItem(title: 'Plan A Visit', path: '/visit'),
                    _NavItem(title: 'About Us', path: '/about'),
                    _NavItem(title: 'Sermons', path: '/sermons'),
                    _NavItem(title: 'Calendar', path: '/calendar'),
                    _NavItem(title: 'Staff & Leaders', path: '/staff'),
                    _NavItem(title: 'Next Steps', path: '/next-steps'),
                    _NavItem(title: 'Live', path: '/live', isLive: true),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MobileNavItem(title: 'Home', path: '/', context: context),
                    _MobileNavItem(title: 'Plan A Visit', path: '/visit', context: context),
                    _MobileNavItem(title: 'About Us', path: '/about', context: context),
                    _MobileNavItem(title: 'Sermons', path: '/sermons', context: context),
                    _MobileNavItem(title: 'Calendar', path: '/calendar', context: context),
                    _MobileNavItem(title: 'Staff & Leaders', path: '/staff', context: context),
                    _MobileNavItem(title: 'Next Steps', path: '/next-steps', context: context),
                    _MobileNavItem(title: 'Live', path: '/live', context: context, isLive: true),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  final String path;
  final bool isLive;
  final bool isCompact;

  const _NavItem({
    required this.title,
    required this.path,
    this.isLive = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 6 : 10),
      child: InkWell(
        onTap: () => context.go(path),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: isCompact ? 8 : 12,
          ),
          decoration: BoxDecoration(
            color: isLive ? Colors.red : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: isCompact ? 13 : 15,
              fontWeight: FontWeight.w500,
              color: isLive ? Colors.white : Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final String title;
  final String path;
  final BuildContext context;
  final bool isLive;

  const _MobileNavItem({
    required this.title,
    required this.path,
    required this.context,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      title: Text(
        title,
        style: TextStyle(
          color: isLive ? Colors.red : Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      trailing: isLive
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'LIVE',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          : Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
      onTap: () {
        Navigator.pop(context);
        context.go(path);
      },
    );
  }
}
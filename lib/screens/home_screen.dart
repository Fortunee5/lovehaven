// lib/screens/home_screen.dart - COMPLETE COMPACT VERSION
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'dart:convert';
import '../providers/content_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  int _currentTestimonyIndex = 0;
  Timer? _testimonyTimer;
  carousel.CarouselSliderController? _testimonyCarouselController;
  bool _hasTestimonies = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (mounted) {
        setState(() {
          _isScrolled = _scrollController.offset > 50;
        });
      }
    });
  }

  void _initializeTestimonyCarousel() {
    if (_hasTestimonies && _testimonyCarouselController == null) {
      _testimonyCarouselController = carousel.CarouselSliderController();
      _startTestimonyTimer();
    }
  }

  void _startTestimonyTimer() {
    _testimonyTimer?.cancel();
    if (_hasTestimonies) {
      _testimonyTimer = Timer.periodic(Duration(seconds: 5), (timer) {
        if (mounted && _testimonyCarouselController != null && _hasTestimonies) {
          try {
            _testimonyCarouselController!.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } catch (e) {
            print('Carousel navigation error: $e');
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _testimonyTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  String? _extractVideoId(String? url) {
    if (url == null || url.isEmpty) return null;
    
    try {
      if (url.contains('youtube.com/watch?v=')) {
        return Uri.tryParse(url)?.queryParameters['v'];
      } else if (url.contains('youtu.be/')) {
        final uri = Uri.tryParse(url);
        if (uri != null && uri.pathSegments.isNotEmpty) {
          return uri.pathSegments[0];
        }
      } else if (url.contains('youtube.com/embed/')) {
        final uri = Uri.tryParse(url);
        if (uri != null && uri.pathSegments.length > 1) {
          return uri.pathSegments[1];
        }
      } else if (!url.contains('/') && !url.contains('.')) {
        return url;
      }
    } catch (e) {
      print('Error extracting video ID: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);
    final heroContent = contentProvider.getContentByType('hero');
    final sermons = contentProvider.getContentByType('sermon').take(3).toList();
    final events = contentProvider.getContentByType('event').take(3).toList();
    final testimonies = contentProvider.getContentByType('testimony');
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    // Update testimonies state
    _hasTestimonies = testimonies.isNotEmpty;
    
    // Initialize carousel if we have testimonies
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTestimonyCarousel();
    });

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Hero Section
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Stack(
                    children: [
                      carousel.CarouselSlider(
                        options: carousel.CarouselOptions(
                          height: double.infinity,
                          viewportFraction: 1.0,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
                        ),
                        items: heroContent.isEmpty
                            ? [_buildDefaultHeroSlide()]
                            : heroContent.map((item) => _buildHeroSlide(item)).toList(),
                      ),
                      Positioned(
                        bottom: 50,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () => context.go('/visit'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              'PLAN YOUR VISIT',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ).animate().fadeIn(delay: 1.seconds).slideY(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Welcome Section
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                  color: Colors.grey[50],
                  child: Column(
                    children: [
                      Text(
                        'Welcome Home',
                        style: TextStyle(
                          fontSize: isMobile ? 32 : 40,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ).animate().fadeIn().scale(),
                      SizedBox(height: 20),
                      Container(
                        constraints: BoxConstraints(maxWidth: 800),
                        child: Text(
                          'We are a church that believes in Jesus, loves God and people. We are passionate about sharing the hope and love of Jesus Christ with our community.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: isMobile ? 16 : 18, height: 1.6),
                        ),
                      ).animate().fadeIn(delay: 300.milliseconds),
                      SizedBox(height: 40),
                      Wrap(
                        spacing: 40,
                        runSpacing: 40,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildInfoCard('Sunday Services', '9:00 AM & 11:00 AM', Icons.access_time),
                          _buildInfoCard('Wednesday Night', '7:00 PM', Icons.nightlight_round),
                          _buildInfoCard('Kids Church', 'Every Service', Icons.child_care),
                        ],
                      ).animate().fadeIn(delay: 500.milliseconds),
                    ],
                  ),
                ),
              ),

              // Recent Sermons
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        'Recent Messages',
                        style: TextStyle(
                          fontSize: isMobile ? 28 : 36,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        constraints: BoxConstraints(maxWidth: 1200),
                        child: sermons.isEmpty
                            ? _buildEmptySermons()
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isMobile ? 1 : (screenWidth < 1000 ? 2 : 3),
                                  crossAxisSpacing: 30,
                                  mainAxisSpacing: 30,
                                  childAspectRatio: 16 / 10,
                                ),
                                itemCount: sermons.length.clamp(0, 3),
                                itemBuilder: (context, index) => _buildSermonCard(sermons[index]),
                              ),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () => context.go('/sermons'),
                        child: Text('VIEW ALL SERMONS', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),

              // Compact Horizontal Testimony Section
              if (testimonies.isNotEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    color: Theme.of(context).primaryColor.withOpacity(0.05),
                    child: Column(
                      children: [
                        Text(
                          'Testimonies',
                          style: TextStyle(
                            fontSize: isMobile ? 24 : 30,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Stories of God\'s faithfulness',
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          height: 180, // Compact height
                          child: _testimonyCarouselController != null
                              ? carousel.CarouselSlider.builder(
                                  carouselController: _testimonyCarouselController,
                                  itemCount: testimonies.length,
                                  options: carousel.CarouselOptions(
                                    height: 180,
                                    viewportFraction: isMobile ? 0.95 : 0.6,
                                    enlargeCenterPage: true,
                                    enlargeStrategy: carousel.CenterPageEnlargeStrategy.height,
                                    autoPlay: false, // We control this manually
                                    onPageChanged: (index, reason) {
                                      if (mounted) {
                                        setState(() {
                                          _currentTestimonyIndex = index;
                                        });
                                      }
                                    },
                                  ),
                                  itemBuilder: (context, index, realIndex) {
                                    if (index < testimonies.length) {
                                      return _buildCompactTestimonyCard(testimonies[index]);
                                    }
                                    return Container();
                                  },
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                        ),
                        if (testimonies.length > 1) ...[
                          SizedBox(height: 16),
                          // Compact Indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: testimonies.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () {
                                  if (_testimonyCarouselController != null) {
                                    _testimonyCarouselController!.animateToPage(entry.key);
                                  }
                                },
                                child: Container(
                                  width: _currentTestimonyIndex == entry.key ? 20.0 : 6.0,
                                  height: 6.0,
                                  margin: EdgeInsets.symmetric(horizontal: 3.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: _currentTestimonyIndex == entry.key
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).primaryColor.withOpacity(0.3),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

              // Upcoming Events
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                  color: Colors.grey[50],
                  child: Column(
                    children: [
                      Text(
                        'Upcoming Events',
                        style: TextStyle(
                          fontSize: isMobile ? 28 : 36,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        constraints: BoxConstraints(maxWidth: 1200),
                        child: events.isEmpty
                            ? _buildEmptyEvents()
                            : Column(
                                children: events.map((event) => _buildEventCard(event)).toList(),
                              ),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () => context.go('/calendar'),
                        child: Text('VIEW CALENDAR', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              SliverToBoxAdapter(
                child: AppFooter(),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppHeader(isScrolled: _isScrolled),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTestimonyCard(dynamic testimony) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Circular Image
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: testimony.mediaUrl != null && testimony.mediaUrl!.startsWith('data:image')
                      ? Image.memory(
                          base64Decode(testimony.mediaUrl!.split(',').last),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildCompactDefaultPersonIcon(),
                        )
                      : testimony.mediaUrl != null
                          ? Image.network(
                              testimony.mediaUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildCompactDefaultPersonIcon(),
                            )
                          : _buildCompactDefaultPersonIcon(),
                ),
              ),
              SizedBox(width: 16),
              // Text Content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimony.title ?? 'Anonymous',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        testimony.content ?? testimony.description ?? 'Testimony content',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.3,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.format_quote,
                          size: 12,
                          color: Theme.of(context).primaryColor.withOpacity(0.5),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Read more',
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).primaryColor.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn().scale(delay: 100.milliseconds),
    );
  }

  Widget _buildCompactDefaultPersonIcon() {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Icon(
        Icons.person,
        size: 35,
        color: Theme.of(context).primaryColor.withOpacity(0.5),
      ),
    );
  }

  Widget _buildEmptySermons() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No sermons available yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyEvents() {
    return Container(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No upcoming events',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultHeroSlide() {
    return Container(
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
              'Welcome to CELVZLOVEHAVEN',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Experience God\'s Love',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSlide(dynamic item) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (item.mediaUrl != null)
          item.mediaUrl!.startsWith('data:image')
              ? Image.memory(
                  base64Decode(item.mediaUrl!.split(',').last),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : Image.network(
                  item.mediaUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Theme.of(context).primaryColor,
                  ),
                )
        else
          Container(color: Theme.of(context).primaryColor),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title ?? '',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (item.description != null) ...[
                  SizedBox(height: 20),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String subtitle, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Theme.of(context).primaryColor),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSermonCard(dynamic sermon) {
    final videoId = _extractVideoId(sermon.mediaUrl);
    final thumbnailUrl = videoId != null 
        ? 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg'
        : null;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.go('/sermons'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                      child: thumbnailUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.network(
                                thumbnailUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  child: Center(
                                    child: Icon(
                                      Icons.play_circle_outline,
                                      size: 50,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.play_circle_outline,
                                size: 50,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                    ),
                    if (videoId != null)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.5),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sermon.title ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (sermon.description != null) ...[
                      SizedBox(height: 5),
                      Text(
                        sermon.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(dynamic event) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.go('/calendar'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        event.date != null ? '${event.date.day}' : '?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        event.date != null ? _getMonthName(event.date.month) : '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (event.description != null) ...[
                      SizedBox(height: 5),
                      Text(
                        event.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return months[month - 1];
  }
}
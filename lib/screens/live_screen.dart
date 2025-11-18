// lib/screens/live_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../providers/content_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';

class LiveScreen extends StatefulWidget {
  @override
  _LiveScreenState createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    if (contentProvider.liveStreamUrl.isNotEmpty) {
      final videoId = _extractVideoId(contentProvider.liveStreamUrl);
      if (videoId != null) {
        _controller = YoutubePlayerController(
          params: YoutubePlayerParams(
            showControls: true,
            mute: false,
            showFullscreenButton: true,
            loop: false,
          ),
        );
        _controller!.loadVideoById(videoId: videoId);
      }
    }
  }

  String? _extractVideoId(String url) {
    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      final uri = Uri.tryParse(url);
      if (uri != null) {
        if (uri.host.contains('youtube.com')) {
          return uri.queryParameters['v'];
        } else if (uri.host.contains('youtu.be')) {
          return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
        }
      }
    }
    return url; // Assume it's already a video ID
  }

  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          AppHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Column(
                      children: [
                        Text(
                          'Live Stream',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 40),
                        if (_controller != null && contentProvider.liveStreamUrl.isNotEmpty) ...[
                          Container(
                            constraints: BoxConstraints(maxWidth: 1200, maxHeight: 675),
                            child: YoutubePlayer(
                              controller: _controller!,
                              aspectRatio: 16 / 9,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle, color: Colors.white, size: 12),
                                SizedBox(width: 8),
                                Text(
                                  'LIVE NOW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          Container(
                            height: 400,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.live_tv,
                                    size: 80,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'No Live Stream Available',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Check back during service times',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 60),
                        Container(
                          constraints: BoxConstraints(maxWidth: 800),
                          padding: EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Service Times',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(height: 20),
                              _buildServiceTime('Sunday Morning', '9:00 AM & 11:00 AM'),
                              _buildServiceTime('Wednesday Night', '7:00 PM'),
                              _buildServiceTime('Youth Service', 'Friday 7:00 PM'),
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

  Widget _buildServiceTime(String title, String time) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.access_time, color: Theme.of(context).primaryColor),
          SizedBox(width: 10),
          Text(
            '$title: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }
}
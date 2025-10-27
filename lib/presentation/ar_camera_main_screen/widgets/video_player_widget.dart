import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoPlayerWidget extends StatefulWidget {
  final bool isVisible;
  final VoidCallback? onVideoEnd;
  final VoidCallback? onNextVideo;
  final VoidCallback? onPreviousVideo;

  const VideoPlayerWidget({
    Key? key,
    required this.isVisible,
    this.onVideoEnd,
    this.onNextVideo,
    this.onPreviousVideo,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _isPlaying = true;
  bool _showControls = true;
  double _currentPosition = 0.3; // Mock progress
  final double _totalDuration = 1.0;

  // Mock video data
  final List<Map<String, dynamic>> _videoPlaylist = [
    {
      "id": 1,
      "title": "Konten AR Interaktif",
      "description":
          "Video demonstrasi fitur AR avatar dengan teknologi terdepan",
      "thumbnail":
          "https://images.unsplash.com/photo-1551053495-efa988165115",
      "semanticLabel":
          "Person wearing VR headset in futuristic blue-lit environment with digital interface elements",
      "duration": "2:45",
      "url": "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4"
    },
    {
      "id": 2,
      "title": "Tutorial Avatar Kustom",
      "description": "Panduan lengkap menggunakan fitur kustomisasi avatar",
      "thumbnail":
          "https://images.unsplash.com/photo-1681398836231-d0b89bd571d6",
      "semanticLabel":
          "3D rendered avatar character with customizable features in modern digital interface",
      "duration": "3:20",
      "url": "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4"
    },
    {
      "id": 3,
      "title": "Teknologi AR Terbaru",
      "description":
          "Eksplorasi teknologi augmented reality dalam aplikasi mobile",
      "thumbnail":
          "https://images.unsplash.com/photo-1663153204626-5d022b1dd250",
      "semanticLabel":
          "Smartphone displaying AR interface with holographic elements floating above the screen",
      "duration": "4:15",
      "url": "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4"
    }
  ];

  int _currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: AppTheme.standardAnimation,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _fadeController.forward();
    }
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _fadeController.forward();
      } else {
        _fadeController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _nextVideo() {
    setState(() {
      _currentVideoIndex = (_currentVideoIndex + 1) % _videoPlaylist.length;
      _currentPosition = 0.0;
      _isPlaying = true;
    });
    widget.onNextVideo?.call();
  }

  void _previousVideo() {
    setState(() {
      _currentVideoIndex = _currentVideoIndex > 0
          ? _currentVideoIndex - 1
          : _videoPlaylist.length - 1;
      _currentPosition = 0.0;
      _isPlaying = true;
    });
    widget.onPreviousVideo?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    final currentVideo = _videoPlaylist[_currentVideoIndex];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: 100.w,
        height: 100.h,
        color: AppTheme.primaryDark,
        child: Stack(
          children: [
            // Video thumbnail/placeholder
            Positioned.fill(
              child: CustomImageWidget(
                imageUrl: currentVideo["thumbnail"] as String,
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
                semanticLabel: currentVideo["semanticLabel"] as String,
              ),
            ),

            // Video overlay
            Positioned.fill(
              child: Container(
                color: AppTheme.primaryDark.withValues(alpha: 0.3),
              ),
            ),

            // Video controls
            if (_showControls)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showControls = !_showControls;
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        // Top controls
                        Container(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 2.h,
                            left: 4.w,
                            right: 4.w,
                            bottom: 2.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppTheme.primaryDark.withValues(alpha: 0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Return to AR mode
                                },
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme.overlayTransparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'arrow_back',
                                    color: AppTheme.textPrimary,
                                    size: 6.w,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentVideo["title"] as String,
                                      style: AppTheme
                                          .darkTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppTheme.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      currentVideo["description"] as String,
                                      style: AppTheme
                                          .darkTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Center play/pause button
                        Expanded(
                          child: Center(
                            child: GestureDetector(
                              onTap: _togglePlayPause,
                              child: Container(
                                width: 20.w,
                                height: 20.w,
                                decoration: BoxDecoration(
                                  color: AppTheme.overlayTransparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.accentCyan
                                        .withValues(alpha: 0.5),
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: CustomIconWidget(
                                    iconName:
                                        _isPlaying ? 'pause' : 'play_arrow',
                                    color: AppTheme.accentCyan,
                                    size: 10.w,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Bottom controls
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppTheme.primaryDark.withValues(alpha: 0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              // Progress bar
                              Row(
                                children: [
                                  Text(
                                    '${(_currentPosition * 4.5).toInt()}:${((_currentPosition * 4.5 % 1) * 60).toInt().toString().padLeft(2, '0')}',
                                    style: AppTheme
                                        .darkTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackHeight: 2,
                                        thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 6,
                                        ),
                                      ),
                                      child: Slider(
                                        value: _currentPosition,
                                        onChanged: (value) {
                                          setState(() {
                                            _currentPosition = value;
                                          });
                                        },
                                        activeColor: AppTheme.accentCyan,
                                        inactiveColor: AppTheme.textSecondary
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    currentVideo["duration"] as String,
                                    style: AppTheme
                                        .darkTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 2.h),

                              // Navigation controls
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: _previousVideo,
                                    child: Container(
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        color: AppTheme.overlayTransparent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: CustomIconWidget(
                                        iconName: 'skip_previous',
                                        color: AppTheme.textPrimary,
                                        size: 8.w,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _togglePlayPause,
                                    child: Container(
                                      padding: EdgeInsets.all(4.w),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accentCyan,
                                        shape: BoxShape.circle,
                                      ),
                                      child: CustomIconWidget(
                                        iconName:
                                            _isPlaying ? 'pause' : 'play_arrow',
                                        color: AppTheme.primaryDark,
                                        size: 10.w,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _nextVideo,
                                    child: Container(
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        color: AppTheme.overlayTransparent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: CustomIconWidget(
                                        iconName: 'skip_next',
                                        color: AppTheme.textPrimary,
                                        size: 8.w,
                                      ),
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
                ),
              ),
          ],
        ),
      ),
    );
  }
}

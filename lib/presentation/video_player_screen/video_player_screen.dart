import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/video_controls_widget.dart';
import './widgets/video_gesture_detector_widget.dart';
import './widgets/video_header_widget.dart';
import './widgets/video_loading_widget.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with TickerProviderStateMixin {
  VideoPlayerController? _videoController;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _showControls = true;
  bool _isBuffering = false;
  int _currentVideoIndex = 0;
  double _currentZoom = 1.0;

  // Auto-hide controls timer
  late AnimationController _controlsAnimationController;

  // Mock video playlist data
  final List<Map<String, dynamic>> _videoPlaylist = [
    {
      "id": 1,
      "title": "Panduan AR Avatar - Kustomisasi Wajah",
      "description":
          "Pelajari cara mengkustomisasi avatar AR Anda dengan berbagai pilihan warna kulit dan aksesori menarik.",
      "url":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      "duration": "04:32",
      "thumbnail":
          "https://images.unsplash.com/photo-1596300919279-0f4fa4136dde",
      "semanticLabel":
          "Close-up of a person's face with AR overlay effects showing customization options",
      "category": "Tutorial"
    },
    {
      "id": 2,
      "title": "Fitur Deteksi Gerakan Terbaru",
      "description":
          "Eksplorasi teknologi deteksi gerakan canggih yang memungkinkan avatar mengikuti setiap gerakan Anda secara real-time.",
      "url":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      "duration": "03:45",
      "thumbnail":
          "https://images.unsplash.com/photo-1709159176902-4c19f7735b93",
      "semanticLabel":
          "Person demonstrating hand gestures in front of camera with motion tracking visualization",
      "category": "Teknologi"
    },
    {
      "id": 3,
      "title": "Koleksi Avatar Premium Terbaru",
      "description":
          "Jelajahi koleksi avatar premium dengan desain eksklusif dan animasi berkualitas tinggi untuk pengalaman AR yang lebih menarik.",
      "url":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      "duration": "02:18",
      "thumbnail":
          "https://images.unsplash.com/photo-1616329900620-9b4d46f5f41b",
      "semanticLabel":
          "Gallery view of various 3D avatar models with different styles and accessories",
      "category": "Konten"
    },
    {
      "id": 4,
      "title": "Tips Pencahayaan untuk AR Optimal",
      "description":
          "Dapatkan hasil AR terbaik dengan memahami pengaturan pencahayaan yang ideal untuk deteksi wajah yang akurat.",
      "url":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
      "duration": "05:12",
      "thumbnail":
          "https://images.unsplash.com/photo-1643327269452-a291a5f3f72a",
      "semanticLabel":
          "Professional lighting setup with person using AR camera application",
      "category": "Tips"
    },
    {
      "id": 5,
      "title": "Berbagi Kreasi AR ke Media Sosial",
      "description":
          "Pelajari cara mudah membagikan video AR kreatif Anda ke berbagai platform media sosial dengan kualitas terbaik.",
      "url":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
      "duration": "03:28",
      "thumbnail":
          "https://images.unsplash.com/photo-1600009710631-5baaaaf50754",
      "semanticLabel":
          "Social media interface showing AR video being shared across multiple platforms",
      "category": "Berbagi"
    },
  ];

  @override
  void initState() {
    super.initState();
    _controlsAnimationController = AnimationController(
      duration: AppTheme.standardAnimation,
      vsync: this,
    );
    _initializeVideo();
    _startControlsTimer();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _controlsAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final videoData = _videoPlaylist[_currentVideoIndex];
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(videoData["url"] as String),
      );

      await _videoController!.initialize();

      _videoController!.addListener(_videoListener);

      setState(() {
        _isLoading = false;
      });

      // Auto-play video
      _playVideo();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Gagal memuat video. Periksa koneksi internet Anda.');
    }
  }

  void _videoListener() {
    if (_videoController != null) {
      final bool isBuffering = _videoController!.value.isBuffering;
      if (isBuffering != _isBuffering) {
        setState(() {
          _isBuffering = isBuffering;
        });
      }

      // Auto-advance to next video when current video ends
      if (_videoController!.value.position >=
              _videoController!.value.duration &&
          _videoController!.value.duration.inMilliseconds > 0) {
        _playNextVideo();
      }
    }
  }

  void _playVideo() {
    _videoController?.play();
    setState(() {
      _isPlaying = true;
    });
  }

  void _pauseVideo() {
    _videoController?.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _pauseVideo();
    } else {
      _playVideo();
    }
    _resetControlsTimer();
  }

  void _playNextVideo() {
    if (_currentVideoIndex < _videoPlaylist.length - 1) {
      setState(() {
        _currentVideoIndex++;
      });
      _switchVideo();
    }
  }

  void _playPreviousVideo() {
    if (_currentVideoIndex > 0) {
      setState(() {
        _currentVideoIndex--;
      });
      _switchVideo();
    }
  }

  Future<void> _switchVideo() async {
    _videoController?.removeListener(_videoListener);
    await _videoController?.dispose();
    await _initializeVideo();
  }

  void _seekVideo(Duration position) {
    _videoController?.seekTo(position);
    _resetControlsTimer();
  }

  void _skipBackward() {
    final currentPosition = _videoController?.value.position ?? Duration.zero;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _seekVideo(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void _skipForward() {
    final currentPosition = _videoController?.value.position ?? Duration.zero;
    final totalDuration = _videoController?.value.duration ?? Duration.zero;
    final newPosition = currentPosition + const Duration(seconds: 10);
    _seekVideo(newPosition > totalDuration ? totalDuration : newPosition);
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startControlsTimer();
    }
  }

  void _startControlsTimer() {
    _controlsAnimationController.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() {
          _showControls = false;
        });
        _controlsAnimationController.reverse();
      }
    });
  }

  void _resetControlsTimer() {
    setState(() {
      _showControls = true;
    });
    _startControlsTimer();
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _currentZoom = (_currentZoom * details.scale).clamp(1.0, 3.0);
    });
  }

  void _showContextMenu() {
    HapticFeedback.mediumImpact();
    // Context menu is handled in VideoHeaderWidget
  }

  void _navigateBack() {
    Navigator.pushReplacementNamed(context, '/ar-camera-main-screen');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.errorCoral,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: _buildVideoPlayer(),
    );
  }

  Widget _buildVideoPlayer() {
    if (_isLoading ||
        _videoController == null ||
        !_videoController!.value.isInitialized) {
      return VideoLoadingWidget(
        isVisible: true,
        message: _isLoading ? 'Memuat video...' : 'Menginisialisasi pemutar...',
      );
    }

    final currentVideo = _videoPlaylist[_currentVideoIndex];

    return Stack(
      children: [
        // Video player
        Center(
          child: Transform.scale(
            scale: _currentZoom,
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          ),
        ),

        // Gesture detector for interactions
        VideoGestureDetectorWidget(
          onTap: _toggleControls,
          onDoubleTapLeft: _skipBackward,
          onDoubleTapRight: _skipForward,
          onSwipeLeft: _playNextVideo,
          onSwipeRight: _playPreviousVideo,
          onScaleUpdate: _handleScaleUpdate,
          onLongPress: _showContextMenu,
          child: Container(),
        ),

        // Top header with video info
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: VideoHeaderWidget(
            videoTitle: currentVideo["title"] as String,
            currentVideoIndex: _currentVideoIndex,
            totalVideos: _videoPlaylist.length,
            isVisible: _showControls,
            onBackPressed: _navigateBack,
          ),
        ),

        // Bottom controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: VideoControlsWidget(
            isPlaying: _isPlaying,
            isVisible: _showControls,
            currentPosition: _videoController?.value.position ?? Duration.zero,
            totalDuration: _videoController?.value.duration ?? Duration.zero,
            onPlayPause: _togglePlayPause,
            onPrevious: _playPreviousVideo,
            onNext: _playNextVideo,
            onSeek: _seekVideo,
          ),
        ),

        // Buffering indicator
        VideoLoadingWidget(
          isVisible: _isBuffering,
          message: 'Buffering...',
        ),
      ],
    );
  }
}

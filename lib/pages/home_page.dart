import 'package:flutter/material.dart';

import '../widgets/custom_styled_button_home.dart';
import 'live_streaming_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Text(
              'Start or Join a Live Stream',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
          
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showStreamOptions(context),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Live Icon with Pulsating Animation
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          PulsingCircle(size: 48, animationEnd: 1.3),
                          PulsingCircle(size: 36, animationEnd: 1.6),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.videocam,
                              color: Color(0xFFFF5722),
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      
                      // Text content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'FoodStream Live',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Share your cooking skills or watch others live!',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Arrow indicator
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //! Shows the dialog with streaming options
  void _showStreamOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with pill indicator
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const Text(
              'Start or Join Stream',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 24),
            
            // Start streaming button
            customBuildOptionButton(
              context,
              icon: Icons.videocam,
              title: 'Start Streaming',
              subtitle: 'Share your kitchen with the world',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LiveStreamPage(isHost: true),
                  ),
                );
              },
              gradient: const LinearGradient(
                colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Join streaming button
            customBuildOptionButton(
              context,
              icon: Icons.live_tv,
              title: 'Join Stream',
              subtitle: 'Watch and learn from others',
              onTap: () {
                Navigator.pop(context);
                _showJoinRoomDialog(context);
              },
              gradient: const LinearGradient(
                colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }


  void _showJoinRoomDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Stream'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Room ID',
                hintText: 'Enter the stream room ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.meeting_room),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              final roomId = controller.text.trim();
              if (roomId.isNotEmpty) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LiveStreamPage(
                      isHost: false,
                      roomId: roomId,
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('JOIN'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}


class PulsingCircle extends StatefulWidget {
  final double size;
  final double animationEnd;
  
  const PulsingCircle({
    super.key,
    required this.size,
    required this.animationEnd,
  });

  @override
  State<PulsingCircle> createState() => _PulsingCircleState();
}

class _PulsingCircleState extends State<PulsingCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _animation = Tween<double>(
      begin: 1.0,
      end: widget.animationEnd,
    ).animate(_controller);
    
    _controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = _animation.value;
        final opacity = widget.animationEnd == 1.0 ? 0.3 : (1 - (value - 1) / (widget.animationEnd - 1)) * 0.3;
        return Container(
          width: widget.size * value,
          height: widget.size * value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(opacity.clamp(0.0, 0.3)),
          ),
        );
      },
    );
  }
}

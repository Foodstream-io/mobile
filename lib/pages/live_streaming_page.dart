// lib/pages/live_stream_page.dart
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/signaling_service.dart';
import '../utils/snackbar_utils.dart';

class LiveStreamPage extends StatefulWidget {
  final bool isHost;
  final String? roomId;

  const LiveStreamPage({super.key, required this.isHost, this.roomId});

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  final SignalingService _signaling = SignalingService();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _isMicMuted = false;
  bool _isCameraOff = false;
  String? _currentRoomId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<bool> _handlePermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.camera, Permission.microphone].request();

    return statuses[Permission.camera]!.isGranted &&
        statuses[Permission.microphone]!.isGranted;
  }

  Future<void> _initialize() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    bool iceServersWorking = await _signaling.testIceConfiguration();
    if (!iceServersWorking) {
      if (mounted) {
        SnackBarUtils.showSnackBar(context, 'ICE servers are not working');
        Navigator.pop(context);
      }
      return;
    }

    bool permissionsGranted = await _handlePermissions();
    if (!permissionsGranted) {
      if (mounted) {
        SnackBarUtils.showSnackBar(context, 'Permissions not granted');
        Navigator.pop(context);
      }
      return;
    }

    bool renderersDisposed = false;

    _signaling.onLocalStream = ((stream) {
      if (!mounted || renderersDisposed) {
        return;
      }

      try {
        _localRenderer.srcObject = stream;
        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error setting local stream: $e');
        }
        if (e.toString().contains('disposed')) {
          renderersDisposed = true;
        }
      }
    });

    _signaling.onRemoteStream = ((stream) {
      if (!mounted || renderersDisposed) {
        return;
      }

      try {
        _remoteRenderer.srcObject = stream;
        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error setting remote stream: $e');
        }
        if (e.toString().contains('disposed')) {
          renderersDisposed = true;
        }
      }
    });

    _signaling.connect('http://192.168.1.94:3000');

    if (!mounted) return;

    try {
      if (widget.isHost) {
        await _signaling.createRoom();
        if (mounted) {
          setState(() {
            _currentRoomId = _signaling.roomId;
          });
        }
      } else if (widget.roomId != null) {
        await _signaling.joinRoom(widget.roomId!);
        if (mounted) {
          setState(() {
            _currentRoomId = widget.roomId;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in room creation/joining: $e');
      }
      if (mounted) {
        SnackBarUtils.showSnackBar(context, 'Error: $e');
      }
    }
  }

  @override
  void dispose() {
    _signaling.onLocalStream = null;
    _signaling.onRemoteStream = null;

    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _signaling.disconnect();
    super.dispose();
  }

  void _toggleMic() {
    if (_signaling.localStream != null) {
      final audioTrack = _signaling.localStream!.getTracks().firstWhere(
        (track) => track.kind == 'audio',
      );

      setState(() {
        _isMicMuted = !_isMicMuted;
        audioTrack.enabled = !_isMicMuted;
      });
    }
  }

  void _toggleCamera() {
    if (_signaling.localStream != null) {
      final videoTrack = _signaling.localStream!.getTracks().firstWhere(
        (track) => track.kind == 'video',
      );

      setState(() {
        _isCameraOff = !_isCameraOff;
        videoTrack.enabled = !_isCameraOff;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isHost ? 'Streaming' : 'Watching Stream'),
        centerTitle: true,
        actions: [
          if (_currentRoomId != null && widget.isHost)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Room ID'),
                        content: SelectableText(_currentRoomId!),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Remote video (full screen)
                RTCVideoView(
                  _remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),

                // Local video (picture-in-picture)
                Positioned(
                  right: 20,
                  top: 20,
                  width: 120,
                  height: 160,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: RTCVideoView(
                        _localRenderer,
                        mirror: true,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Controls
          Container(
            color: Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    _isMicMuted ? Icons.mic_off : Icons.mic,
                    color: Colors.white,
                  ),
                  onPressed: _toggleMic,
                ),
                IconButton(
                  icon: Icon(
                    _isCameraOff ? Icons.videocam_off : Icons.videocam,
                    color: Colors.white,
                  ),
                  onPressed: _toggleCamera,
                ),
                IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.red),
                  onPressed: () {
                    _signaling.disconnect();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// lib/services/signaling_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SignalingService {
  // Singleton pattern
  static final SignalingService _instance = SignalingService._internal();
  factory SignalingService() => _instance;
  SignalingService._internal();
  bool isHost = false;

  io.Socket? socket;
  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun.l.google.com:19302',
        ],
      },
      {
        'urls': 'turn:your.domain.com:3478',
        'username': 'zawa',
        'credential': '1234'
      }
    ],
    'offerToReceiveAudio': true,
    'offerToReceiveVideo': true,
    'codec': 'vp8',
  };

  Future<bool> testIceConfiguration() async {
    try {
      RTCPeerConnection testPC = await createPeerConnection(configuration);
      List<RTCIceCandidate> candidates = [];

      testPC.onIceCandidate = (candidate) {
        if (kDebugMode) {
          print("ICE candidate: ${candidate.candidate}");
        }
        candidates.add(candidate);
      };

      testPC.onIceGatheringState = (state) {
        if (kDebugMode) {
          print("ICE gathering state: $state");

          if (state == RTCIceGatheringState.RTCIceGatheringStateComplete) {
            bool hasServerReflexive = candidates.any(
              (c) => c.candidate?.contains('srflx') ?? false,
            );
            bool hasRelay = candidates.any(
              (c) => c.candidate?.contains('relay') ?? false,
            );

            print("Found server reflexive candidates: $hasServerReflexive");
            print("Found relay candidates: $hasRelay");
          }
        }
      };

      testPC.createDataChannel('test', RTCDataChannelInit());
      await testPC.createOffer({});

      await Future.delayed(const Duration(seconds: 5));
      await testPC.close();

      return candidates.any(
        (c) =>
            (c.candidate?.contains('srflx') ?? false) ||
            (c.candidate?.contains('relay') ?? false),
      );
    } catch (e) {
      if (kDebugMode) {
        print("ICE test failed: $e");
      }
      return false;
    }
  }

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? roomId;
  String? currentUserId;

  Function(MediaStream)? onLocalStream;
  Function(MediaStream)? onRemoteStream;

  void connect(String serverUrl) {
    socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.on('connect', (_) {
      if (kDebugMode) {
        print('Connected to signaling server with ID: ${socket!.id}');
      }
      currentUserId = socket!.id;
    });

    socket!.on('offer', (data) async {
      if (kDebugMode) {
        print('Received offer from: ${data['userId']}');
      }
      await handleOffer(data);
    });

    socket!.on('answer', (data) async {
      if (kDebugMode) {
        print('Received answer from: ${data['userId']}');
      }
      await handleAnswer(data);
    });

    socket!.on('ice-candidate', (data) async {
      if (kDebugMode) {
        print('Received ICE candidate from: ${data['userId']}');
      }
      await handleIceCandidate(data);
    });

    socket!.on('user-joined', (data) async {
      if (kDebugMode) {
        print('User joined: ${data['userId']}');
      }

      if (isHost) {
        RTCSessionDescription offer = await peerConnection!.createOffer();
        await peerConnection!.setLocalDescription(offer);

        socket!.emit('offer', {
          'roomId': roomId,
          'sdp': offer.sdp,
          'type': offer.type,
          'userId': currentUserId,
        });
      }
    });

    socket!.on('host-left', (_) {
      if (kDebugMode) {
        print('Host left the room');
      }
    });
  }

  Future<void> createRoom() async {
    try {
      roomId = DateTime.now().millisecondsSinceEpoch.toString();
      isHost = true;
      if (kDebugMode) {
        print("Creating room with ID: $roomId");
      }

      await _createPeerConnection();

      socket!.emit('create-room', {'roomId': roomId});
    } catch (e) {
      if (kDebugMode) {
        print("Error creating room: $e");
      }
    }
  }

  Future<void> joinRoom(String roomId) async {
    try {
      this.roomId = roomId;
      isHost = false;
      if (kDebugMode) {
        print("Joining room with ID: $roomId");
      }

      await _createPeerConnection();

      socket!.emit('join-room', {'roomId': roomId, 'userId': currentUserId});
    } catch (e) {
      if (kDebugMode) {
        print("Error joining room: $e");
      }
    }
  }

  Future<void> _createPeerConnection() async {
    peerConnection = await createPeerConnection(configuration);

    peerConnection!.onConnectionState = (RTCPeerConnectionState state) {
      if (kDebugMode) {
        print("Connection state changed to: $state");
      }
    };

    peerConnection!.onIceConnectionState = (RTCIceConnectionState state) {
      if (kDebugMode) {
        print("ICE connection state changed to: $state");
      }
    };

    peerConnection!.onIceGatheringState = (RTCIceGatheringState state) {
      if (kDebugMode) {
        print("ICE gathering state changed to: $state");
      }
    };

    localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {'facingMode': 'user'},
    });

    localStream!.getTracks().forEach((track) {
      peerConnection!.addTrack(track, localStream!);
    });

    if (onLocalStream != null) {
      onLocalStream!(localStream!);
    }

    peerConnection!.onTrack = (RTCTrackEvent event) {
      if (kDebugMode) {
        print("Received track: ${event.track.kind}");
      }

      if (event.streams.isNotEmpty) {
        remoteStream = event.streams[0];
        if (onRemoteStream != null) {
          onRemoteStream!(remoteStream!);
        }
      }
    };

    peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      if (kDebugMode) {
        print("Generated ICE candidate: ${candidate.candidate}");
      }

      socket!.emit('ice-candidate', {
        'roomId': roomId,
        'candidate': candidate.toMap(),
        'userId': currentUserId,
      });
    };
  }

  Future<void> handleOffer(dynamic data) async {
    try {
      await peerConnection!.setRemoteDescription(
        RTCSessionDescription(data['sdp'], data['type']),
      );
      peerConnection?.onIceCandidate = (candidate) {
        if (kDebugMode) {
          print('ICE candidate retry: ${candidate.toMap()}');
        }
        socket!.emit('ice-candidate', {
          'roomId': roomId,
          'candidate': candidate.toMap(),
          'userId': currentUserId,
        });
      };

      if (kDebugMode) {
        print("Set remote description from offer");
      }

      final answer = await peerConnection!.createAnswer();
      await peerConnection!.setLocalDescription(answer);

      if (kDebugMode) {
        print("Created and set local description for answer");
      }

      socket!.emit('answer', {
        'roomId': roomId,
        'sdp': answer.sdp,
        'type': answer.type,
        'userId': currentUserId,
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error handling offer: $e");
      }
    }
  }

  Future<void> handleAnswer(dynamic data) async {
    try {
      await peerConnection!.setRemoteDescription(
        RTCSessionDescription(data['sdp'], data['type']),
      );

      if (kDebugMode) {
        print("Set remote description from answer");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error handling answer: $e");
      }
    }
  }

  Future<void> handleIceCandidate(dynamic data) async {
    if (data['candidate'] != null) {
      try {
        await peerConnection!.addCandidate(
          RTCIceCandidate(
            data['candidate']['candidate'],
            data['candidate']['sdpMid'],
            data['candidate']['sdpMLineIndex'],
          ),
        );

        if (kDebugMode) {
          print("Added ICE candidate from remote peer");
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error adding ICE candidate: $e");
        }
      }
    }
  }

  void disconnect() {
    if (kDebugMode) {
      print("Disconnecting from room: $roomId");
    }

    localStream?.getTracks().forEach((track) => track.stop());
    peerConnection?.close();
    socket?.disconnect();
  }
}

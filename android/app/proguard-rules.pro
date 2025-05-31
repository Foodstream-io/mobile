# Add project specific ProGuard rules here.

# Keep Flutter engine
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep WebRTC classes
-keep class org.webrtc.** { *; }
-keep class io.flutter.plugins.webrtc.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep LiveKit classes
-keep class org.livekit.** { *; }
-keep class livekit_client.** { *; }
-dontwarn org.livekit.**

# Keep socket.io classes for signaling
-keep class io.socket.** { *; }
-dontwarn io.socket.**

# Keep permission handler classes
-keep class com.baseflow.permissionhandler.** { *; }

# Keep JSON serialization for WebRTC signaling
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes InnerClasses

# Keep HTTP client classes
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# Keep Google Play Core classes
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep Flutter Play Store classes
-keep class io.flutter.embedding.android.FlutterPlayStoreSplitApplication { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

# Keep tasks and listeners
-keep class com.google.android.play.core.tasks.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }

# Fix the Java version warnings
-keepattributes SourceFile,LineNumberTable
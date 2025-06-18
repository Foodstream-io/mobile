FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    libglu1-mesa \
    openjdk-17-jdk \
    software-properties-common \
    sudo \
    unzip \
    wget \
    xz-utils \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Set Java environment
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# Create flutter user and cache directories
RUN useradd -m -u 1000 -s /bin/bash flutter && \
    echo "flutter ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /opt/flutter-cache /opt/pub-cache /opt/gradle-cache && \
    chown -R flutter:flutter /opt/flutter-cache /opt/pub-cache /opt/gradle-cache

# Install Android SDK
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/34.0.0

RUN mkdir -p "$ANDROID_HOME" && \
    cd "$ANDROID_HOME" && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip commandlinetools-linux-*.zip && \
    rm commandlinetools-linux-*.zip && \
    mkdir -p cmdline-tools/latest && \
    mv cmdline-tools/* cmdline-tools/latest/ || true && \
    chown -R flutter:flutter "$ANDROID_HOME" && \
    yes | "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager --licenses && \
    "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager \
    "platform-tools" \
    "platforms;android-31" \
    "platforms;android-34" \
    "platforms;android-35" \
    "build-tools;31.0.0" \
    "build-tools;34.0.0" \
    "build-tools;35.0.0" \
    "ndk;27.0.12077973"

# Install Flutter as root initially
ENV FLUTTER_HOME=/opt/flutter
ENV PATH=$PATH:$FLUTTER_HOME/bin
ENV PUB_CACHE=/opt/pub-cache

RUN git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_HOME" && \
    chown -R flutter:flutter "$FLUTTER_HOME" && \
    chmod -R 755 "$FLUTTER_HOME" && \
    git config --global --add safe.directory "$FLUTTER_HOME"

# Switch to flutter user
USER flutter
WORKDIR /home/flutter

# Configure Flutter and add safe directory for flutter user too
RUN git config --global --add safe.directory "$FLUTTER_HOME" && \
    flutter config --android-sdk "$ANDROID_HOME" && \
    flutter doctor

# Create a startup script to handle permissions
USER root
RUN echo '#!/bin/bash\n\
    chown -R flutter:flutter /app 2>/dev/null || true\n\
    git config --global --add safe.directory /opt/flutter 2>/dev/null || true\n\
    exec sudo -u flutter "$@"' > /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# Create working directory and set proper ownership
WORKDIR /app
RUN chown -R flutter:flutter /app

# Copy pubspec files first for better caching
COPY --chown=flutter:flutter pubspec.yaml pubspec.lock ./

# Switch to flutter user and get dependencies
USER flutter
RUN flutter pub get

# Switch back to root to copy remaining files
USER root
COPY . .
RUN chown -R flutter:flutter /app

# Expose port for Flutter web (if needed)
EXPOSE 3000

# Use entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bash"]
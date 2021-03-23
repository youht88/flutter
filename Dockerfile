FROM ubuntu
MAINTAINER youht

WORKDIR /opt

RUN apt-get update -y
RUN apt-get install -y wget git xz-utils curl vim iputils-ping net-tools tmux unzip

#add flutter
ENV PUB_HOSTED_URL=https://pub.flutter-io.cn
ENV FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
ADD flutter_linux_2.0.3-stable.tar.xz /opt/
ENV FLUTTER_HOME=/opt/flutter
ENV PATH=$PATH:$FLUTTER_HOME/bin

#add java
ADD jdk-8u211-linux-x64.tar.gz /opt/
ENV JAVA_HOME=/opt/jdk1.8.0_211
ENV PATH=$PATH:$JAVA_HOME/bin

#add android-sdk
RUN mkdir -p /opt/android/sdk
COPY cmdline-tools /opt/android/sdk/cmdline-tools
ENV ANDROID_SDK=/opt/android/sdk
ENV PATH=$PATH:$ANDROID_SDK/cmdline-tools/bin:$ANDROID_SDK/platform-tools

RUN yes | sdkmanager --sdk_root=$ANDROID_SDK "platforms;android-28"
RUN yes | sdkmanager --sdk_root=$ANDROID_SDK "platforms;android-30"
RUN yes | sdkmanager --sdk_root=$ANDROID_SDK "build-tools;28.0.3"
RUN yes | sdkmanager --sdk_root=$ANDROID_SDK "build-tools;30.0.3"
RUN yes | sdkmanager --sdk_root=$ANDROID_SDK "platforms;android-29"
RUN yes | sdkmanager --sdk_root=$ANDROID_SDK "system-images;android-30;google_apis_playstore;x86"

#add gradle
#COPY gradle-6.5 /opt/gradle-6.5
#ENV GRADLE_HOME=/opt/gradle-6.5/bin

#add python3
RUN apt-get install python3 -y

RUN yes | flutter doctor --android-licenses

#add devTools
RUN flutter pub global activate devtools

#add fix
COPY fix /usr/local/bin
RUN chmod 700 /usr/local/bin/fix

COPY README.md /opt

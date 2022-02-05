FROM openjdk:11-jdk

MAINTAINER mtzhisham

ENV ANDROID_COMPILE_SDK=30
ENV ANDROID_BUILD_TOOLS=30.0.2
ENV ANDROID_SDK_TOOLS=4333796

RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 
RUN apt-get -qq install curl
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip
RUN unzip -d android-sdk-linux android-sdk.zip
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" >/dev/null
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "platform-tools" >/dev/null
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" >/dev/null

ENV ANDROID_HOME=$PWD/android-sdk-linux
ENV PATH=$PATH:$PWD/android-sdk-linux/platform-tools/

RUN yes | android-sdk-linux/tools/bin/sdkmanager --licenses

ENV GRADLE_USER_HOME=$PWD/.gradle

# Install Fastlane
RUN apt-get update && \
    apt-get install --no-install-recommends -y --allow-unauthenticated build-essential git ruby-full && \
    gem install rake && \
    gem install fastlane && \
    gem install bundler
# Clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean

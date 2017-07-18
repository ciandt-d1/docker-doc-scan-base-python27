FROM python:2.7.13

ENV BUILD_PACKAGES \
    curl \
    git \
    g++ \
    autoconf \
    automake \
    build-essential \
    checkinstall \
    cmake \
    pkg-config \
    yasm \
    libtool \
    v4l-utils \
    wget \
    tmux \
    unzip \
    libtiff5-dev \
    libpng-dev \
    libjpeg-dev \
    libjasper-dev \
    libswscale-dev \
    libdc1394-22-dev \
    libxine2-dev \
    libv4l-dev \
    libtbb-dev \
    libopencore-amrnb-dev \
    libopencore-amrwb-dev \
    libtheora-dev \
    libxml2-dev \
    libxslt1-dev


ENV OPENCV_VERSION=3.2.0

WORKDIR /tmp

# Install opencv prerequisites...
RUN apt-get update -qq && \
    apt-get install -y --force-yes $BUILD_PACKAGES && \ 
    apt-get clean && \
    pip2 install --no-cache-dir numpy && \
    wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
    unzip ${OPENCV_VERSION}.zip && \
    cd /tmp/opencv-${OPENCV_VERSION} && \
    mkdir /tmp/opencv-${OPENCV_VERSION}/build && \
    cd /tmp/opencv-${OPENCV_VERSION}/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D WITH_TBB=ON \
          -D WITH_V4L=OFF \
          -D INSTALL_PYTHON_EXAMPLES=OFF \
          -D BUILD_EXAMPLES=OFF \
          -D BUILD_DOCS=OFF \
          -D WITH_XIMEA=OFF \
          -D WITH_QT=OFF \
          -D WITH_FFMPEG=OFF \
          -D WITH_PVAPI=YES \
          -D WITH_GSTREAMER=OFF \
          -D WITH_TIFF=YES \
          -D WITH_OPENCL=YES \
          -D WITH_1394=OFF \
          -D BUILD_PYTHON_SUPPORT=ON \
          -D BUILD_opencv_python2=ON \
          -D BUILD_opencv_python3=OFF \
          -D PYTHON2_EXECUTABLE=/usr/local/bin/python \
          -D PYTHON2_INCLUDE_DIR=/usr/local/include/python2.7 \
          -D PYTHON2_LIBRARY=/usr/local/lib/libpython2.7.so \
          -D PYTHON_LIBRARY=/usr/local/lib/libpython2.7.so \
          -D PYTHON2_PACKAGES_PATH=/usr/local/lib/python2.7/site-packages \
          -D PYTHON2_NUMPY_INCLUDE_DIRS=/usr/local/lib/python2.7/site-packages/numpy/core/include \
          .. && \
    make -j2  && \
    make install && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf && \
    ldconfig && \
    rm -rf /tmp/opencv-${OPENCV_VERSION} && \
    rm -rf /tmp/${OPENCV_VERSION}.zip && \
    apt-get purge -y --force-yes $BUILD_PACKAGES && \
    apt-get autoremove -y --force-yes && \
    apt-get install -y --force-yes libtbb2

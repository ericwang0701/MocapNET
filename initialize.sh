#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"


if [ ! -f ./MotionCapture ]; then
echo "Could not find MotionCapture"
wget http://ammar.gr/datasets/CMUMotionCaptureDatasets.zip
unzip CMUMotionCaptureDatasets.zip
mv CMUMotionCaptureDatasets.zip MotionCapture
fi


QUALITY="1.0" #1.0 , 1.5 , 2.0

mkdir combinedModel
cd combinedModel
if [ ! -f combinedModel/all.pb ]; then
  wget http://ammar.gr/datasets/combinedModel/$QUALITY/all.pb
fi

if [ ! -f combinedModel/back.pb ]; then
  wget http://ammar.gr/datasets/combinedModel/$QUALITY/back.pb
fi

if [ ! -f combinedModel/front.pb ]; then
  wget http://ammar.gr/datasets/combinedModel/$QUALITY/front.pb
fi

if [ ! -f combinedModel/openpose_model.pb ]; then
  wget http://ammar.gr/datasets/combinedModel/openpose_model.pb
fi

if [ ! -f combinedModel/vnect_sm_pafs_8.1k.pb ]; then
  wget http://ammar.gr/datasets/combinedModel/vnect_sm_pafs_8.1k.pb
fi

#if [ ! -f combinedModel/mobnet2_tiny_vnect_sm_1.9k.pb ]; then
#  wget http://ammar.gr/datasets/combinedModel/mobnet2_tiny_vnect_sm_1.9k.pb
#fi
 
cd "$DIR"

#If you have an old GPU then use older version 
TENSORFLOW_VERSION="1.14.0" # 1.12.0 for CUDA 9.0 / 1.11.0 for CUDA9 with  older compute capabilities (5.2) ..
#https://www.tensorflow.org/install/lang_c
if [ ! -f /usr/local/libtensorflow.so ]; then
 echo "Did not find tensorflow"
 wget https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-gpu-linux-x86_64-$TENSORFLOW_VERSION.tar.gz
 echo "Please give me sudo permissions to install Tensorflow $TENSORFLOW_VERSION C Bindings.."
 sudo tar -C /usr/local -xzf libtensorflow-gpu-linux-x86_64-$TENSORFLOW_VERSION.tar.gz
fi


if [ ! -f RGBDAcquisition ]; then
 git clone https://github.com/AmmarkoV/RGBDAcquisition
 cd RGBDAcquisition
 mkdir build
 cd build
 cmake ..
 make 
 cd "$DIR"
 cd ../opengl_acquisition_shared_library/opengl_depth_and_color_renderer
 mkdir build
 cd build
 cmake ..
 make 
 cd "$DIR"
fi



if [ ! -f AmmarServer ]; then
 git clone https://github.com/AmmarkoV/AmmarServer
 cd AmmarServer
 mkdir build
 cd build
 cmake ..
 make 
 cd "$DIR"
fi
 
 
#Now that we have everything lets build..
cd "$DIR"
mkdir build
cd build
cmake ..
make 
cd "$DIR"


exit 0
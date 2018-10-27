#!/bin/bash

# ffmpeg-video-converter - A video converter shell script
# Author: Mahmoud Shiri Varamini <shirivaramini@gmail.com>
# License: GNU General Public License, version 2.
# Redistribution/Reuse of this code is permitted under the GNU v2 license.
# As an additional term ALL code must carry the original Author credit in comment form.
# See LICENSE in this directory for the integral text.

# exit status manual
# 0     successful
# 1     ffmpeg required packages dosen't exist



# Keep in mind that the setdar filter does not modify the pixel dimensions of the video frame.
# Also, the display aspect ratio set by this filter may be changed by later filters in the
# filterchain, e.g. in case of scaling or if another "setdar" or a "setsar" filter is applied.
# you cat set setsar to 16/9(16:9) or 4/3(4:3)
setsar=4/3

# scale watermark according video resolution,for example you want scale watermark to 10% of video
# width and 5% of height ,you should set width_scale=10 and height_scale=20
width_scale=7
height_scale=7

# path of watermark file
watermark=/usr/local/3.png

# path of video files that you want convert them
input_video_path=/opt

# before converting video, input_video_list_maker function run and make a list of video that sholud
# be convert.the result of fuction will be write to video_list.txt file.
input_video_list=/tmp/video_list.txt

# after converting video, the converted video will be placed on below path
output_video_path=/opt/test

# all of operation log on the below path
log_file_path=/var/log/video-converter


# functions
preparation() {

# check if required package is installed or not.(ffmpeg package)
if ! rpm -qa | awk '/^ffmpeg-[0-9]/ && /^ffmpeg-lib*/' ; then
        echo "ffmpeg package dose not exist.pleae install it then try again"
        exit 1
fi
# check log path directory.If the directory didn't exist, the directory will be create
if [ ! -d $log_file_path ];then
mkdir -p $log_file_path
fi
}



# analysis files on input_video_path , and create a list of video files
input_video_list_maker() {
find $input_video_path  -maxdepth 1 -type f  -exec file -N -i -- {} + | sed -n 's!: video/[^:]*$!!p' > $input_video_list ;
}


# convert video files via ffmpeg
video_convert() {
for video in $(cat $input_video_list);do
# get input video width
current_scale_width=$(ffmpeg -i $video  2>&1 | grep -oP 'Stream .*, \K[0-9]+x[0-9]+' | cut -d'x' -f1)
# get input video height
current_scale_height=$(ffmpeg -i $video 2>&1 | grep -oP 'Stream .*, \K[0-9]+x[0-9]+' | cut -d'x' -f2)


# change video resolution according your needs,for example we want to convert video for a video content delivery network(VCDN)
# and VCDN only accept 1920x1080, 1280x720, 768x576, 720x576, 720x480 resoultion
# so first script check input video resolution, if vidoe resolution dose not aline CDN standard, script change resolution
# according standards
if [ $current_scale_width  -ge 1920 ]; then
final_scale="1920x1080"
elif [ $current_scale_width  -ge 1280 -a $current_scale_width  -lt 1920 ]; then
final_scale="1280x720"
elif [ $current_scale_width  -ge 768 -a $current_scale_width  -lt 1280 ]; then
final_scale="768x576"
elif [ $current_scale_width  -ge 720 -a $current_scale_width  -lt 768 -a $current_scale_height -ge 576 ]; then
final_scale="720x576"
elif [ $current_scale_width  -ge 720 -a $current_scale_width  -lt 768 -a $current_scale_height -ge 480 -a $current_scale_height -lt 576 ]; then
final_scale="720x480"
fi


# calculate watermark resolution according output_videos resolution
val=$(echo $final_scale | awk 'BEGIN {FS="x"} {print int($1/7)"x"int($2/7)}')
output_video_name=$(echo $video | awk -F "/" '{print $NF}')

# ffmpeg command that convert video
ffmpeg -i $video  -i $watermark -filter_complex "[1:v] scale=$val [logo1]; [0:v][logo1] overlay=5:main_h-overlay_h,scale=$final_scale,setsar=$setsar" -codec:a copy  -flags global_header $output_video_path/$output_video_name #> $log_file_path/stdout.log 2> $log_file_path/stderr.log
done
rm -rf $input_video_list
}


# main
preparation
input_video_list_maker
video_convert
exit 0

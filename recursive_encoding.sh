#!/bin/bash

output_dir='./_ENCODED'
old_dir='./_OLD'
ffmpeg_params="-c:v libx264 -preset fast -crf 19 -c:a libfdk_aac -b:a 320k\
 -pix_fmt yuv420p -color_range 1 -map 0 -map_metadata 0 -movflags use_metadata_tags"

script_to_run='
mkdir -p "$1"/"$(dirname "$0")";
mkdir -p "$2"/"$(dirname "$0")";
read -r -d "\n" video_check field_order <<< $(mediainfo --Output="Video;%StreamCount%\n%ScanOrder%" "$0");

if [[ -n $video_check ]]; then
    output_format=".mp4"
    if [[ $field_order == "TFF" ]]; then
        interlaced_params=-"flags +ilme+ildct -x264-params tff=1"
    elif [[ $field_order == "BFF" ]]; then
        interlaced_params="-flags +ilme+ildct -x264-params bff=1"
    else
        interlaced_parms=""
    fi
else
    output_format=".m4a"
fi

ffmpeg -i "$0" $3 $interlaced_params "$1"/"${0%.*}$output_format" && mv "$0" "$2"/"$(dirname "$0")" && mv "$1"/"${0%.*}$output_format" "$(dirname "$0")";
'

find -E . -type f -iregex '.*\.(mov|mp4|aif|aiff|wav)' -name "[!.]*" \
-exec bash -c "$script_to_run" {} "$output_dir" "$old_dir" "$ffmpeg_params" \;
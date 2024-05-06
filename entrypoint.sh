#!/bin/sh

# Set default values if environment variables are not set
VIDEO_NAME=${VIDEO_NAME:-video1.mp4}
SRT_IP=${SRT_IP:-0.0.0.0}
SRT_PORT=${SRT_PORT:-4900}
OVERLAY_TEXT=${OVERLAY_TEXT:-"Default Text"}
LOGO_ENABLED=${LOGO_ENABLED:-true}
LISTENER_MODE=${LISTENER_MODE:-false}

# Determine the SRT mode based on the LISTENER_MODE flag
if [ "$LISTENER_MODE" = true ]; then
    SRT_MODE="mode=listener"
else
    SRT_MODE=""
fi

# Run ffmpeg command in a loop with custom text overlay and conditionally apply logo
while true; do
    if [ "$LOGO_ENABLED" = true ]; then
        ffmpeg -re -i /videos/$VIDEO_NAME -i /logo.png -filter_complex "\
            [1:v]scale=iw*0.05:-1[logo];\
            [0:v]drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf:fontsize=24:fontcolor=white:box=1:boxcolor=black@0.5:boxborderw=5:x=(w-text_w)/2:y=h-th-10:text='$OVERLAY_TEXT'[text];\
            [text][logo]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2[out]" \
            -map "[out]" -map 0:a -c:v libx264 -c:a aac -strict -2 -y \
            -f mpegts "srt://$SRT_IP:$SRT_PORT?$SRT_MODE&pkt_size=1316"
    else
        ffmpeg -re -i /videos/$VIDEO_NAME -filter_complex "\
            [0:v]drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf:fontsize=24:fontcolor=white:box=1:boxcolor=black@0.5:boxborderw=5:x=(w-text_w)/2:y=h-th-10:text='$OVERLAY_TEXT'[out]" \
            -map "[out]" -map 0:a -c:v libx264 -c:a aac -strict -2 -y \
            -f mpegts "srt://$SRT_IP:$SRT_PORT?$SRT_MODE&pkt_size=1316"
    fi
done

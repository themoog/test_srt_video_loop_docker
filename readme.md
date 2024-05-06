sudo docker run --rm --name videoloop \\
    -e VIDEO_NAME=video2.mp4 \\
    -p 4900:4900/udp \\
    -e SRT_IP=192.168.1.121 \\
    -e SRT_PORT=4900 \\
    -e OVERLAY_TEXT="Custom Overlay Text" \\
    -e LOGO_ENABLED=true \\
    -e SRT_MODE=true \\
    -e LISTENER_MODE=true \\
    ffmpeg_video_source_srt_listener --bind 192.168.1.153

VIDEO_NAME: Name of the video file to stream. Defaults to video1.mp4.
SRT_IP: IP address to bind the SRT server. Defaults to 0.0.0.0.
SRT_PORT: Port number for the SRT server. Defaults to 4900.
OVERLAY_TEXT: Text to overlay on the video stream. Defaults to "Default Text".
LOGO_ENABLED: Enable/disable overlaying a logo on the video stream. Defaults to true.
SRT_MODE: Set to true to enable SRT mode. Defaults to true.
LISTENER_MODE: Set to true to enable listener mode for SRT. Defaults to true.

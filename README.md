# Rename Subtitles Script

Ruby Script for renaming subtitles in a folder. It identifies the video files and the subtitle files and organize them in episodes, so each episode will have the same name for video and subtitle 

# How To

This script only works in Unix-like systems. **Ruby must be installed on the system**.
Just download the script [`lib/renamesubtitles.rb`](https://github.com/woqer/RenameSubtitlesScript/blob/master/lib/renamesubtitles.rb) and execute it in the desired folder.
You can copy it to `/usr/bin` if you want it to be accessible globally.

* The folder must contain the video files and the subtitles files
* Supported video formats:
    * ["mkv", "avi", "mp4", "flv", "vob", "ogv", "ogg", "gifv", "mov", "wmv", "rm", "rmvb", "asf", "m4v", "mpg", "mpeg", "mp2", "mpv", "mpe", "m2v", "3gp"]
* Supported subtitle formats:
    * ["srt", "sub", "sbv", "ttxt", "smi", "stl", "ass", "ssa", "usf", "idx"] 
    
Author: [Wilfrido Vidana](wvidanas@gmail.com)

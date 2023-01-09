# Recursively Encode Media Files

Bash script that uses FFmpeg and MediaInfo to recursively encode media files for archiving purposes. Preserves timecode and interlacing and passes through common metadata.

## Requirements:

This script requires `ffmpeg` and `mediainfo` to be in your `$PATH`

If you don't have `ffmpeg` installed with `libfdk_aac` this can be replaced with just `aac`

## Basic usage:

First, `cd` into the top level directory where the footage to be encoded is located.
Then make sure you have the `$output_dir` and `$ffmpeg_params` properly set for your system / use case.

The script will then recursively find and encode each video and audio file using the settings in `$ffmpeg_params`
and create an identical folder structure for each file's location in the directory defined in `$output_dir`.

By default, once each file is encoded the old file is moved to the `$old_dir` location and the encoded file is moved back to the original file's location. This preservation of the original files is for safety reasons but the script can be easily modified to just remove the old files after encoding.

## Misc technical notes:

The regular expression in the `find` command can be expanded to include more than just the default of `(mov|dv|aif|aiff|wav)`

There is also a negative glob pattern in the `find` command that excludes hidden files `-name "[!.]*"`

`ffprobe` can also be used in place of `mediainfo` for interlacing detection given the correct settings, but in testing I found that `ffprobe` was unable to detect interlacing in several video files while I never encountered that issue with `mediainfo`.
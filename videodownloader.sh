#!/bin/bash
# This script automatically downloads videos or audios from URLs
# Dependencies: youtube-dl

display_help () {

cat << EOF
Usage: ./videodownloader.sh [OPTIONS] -f [URLFILE]...
./videodownloader.sh [-h] [-t n] -f [URLFILE]
e.g. ./videodownloader.sh -t 18 -f dloadlinks.txt

Takes URLs listed in a text file and automatically downloads corresponding videos or audios

Mandatory arguments include -f PATH_TO_URLFILE
Where:
  -t    typically use -t 18 for mp4 video with sound or -t 249 for webm audio only
   n	this is the integer representing the video or audio format for youtube-dl
  -f    file containing the list of URLs to download video or audio
  -h    give this help

Report bugs to <Olaitan I. Awe - laitanawe@gmail.com>
EOF

}


#$usage="./videodownloader.sh [OPTIONS] -f [FILE]
#./videodownloader.sh [-h] [-t n] -f [FILE]
#e.g. ./videodownloader.sh -t 18 -f dloadlinks.txt

#Takes URLs listed in a text file and automatically downloads corresponding videos or audios

#Mandatory arguments to long options are mandatory for short options too.
#  -t	typically use -t 18 for mp4 video with sound or -t 249 for webm audio only
#  -f	file containing the list of URLs to download video or audio
#  -h	give this help

#Report bugs to Olaitan I. Awe - laitanawe@gmail.com"

# Specify default parameters if not supplied
TYPEFORMAT=250
counturl=0

while getopts t:hf: option
do
case "${option}"
in
   h) display_help
      exit
      ;;
   t) TYPEFORMAT=${OPTARG}
      ;;
   f) FILE_DLOAD=$OPTARG
      ;;
   :) printf "missing argument for -%s\n" "$OPTARG" >&2
      echo "$usage" >&2
      exit 1
      ;;
  \?) printf "illegal option: -%s\n" "$OPTARG" >&2
      echo "$usage" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

# Pick up all the resulting Run ID's and put it into an array
run_ids_array=(`awk '{print $1}' ${FILE_DLOAD}`)

# We have one line for each URL and we run them sequentially
for run_id in "${run_ids_array[@]}"

do
((counturl++))
echo "Currently processing URL"$counturl ": " $run_id

# If we do have a type format of 18 or 249 then we print MP4 or WEBM to screen
if [ $TYPEFORMAT == 18 ]
  then
     echo "Download Format Used: MP4"
elif [ $TYPEFORMAT -eq 249 ]
  then
     echo "Download Format Used: WEBM"
elif [ $TYPEFORMAT -eq 250 ]
  then
     echo "Using Default Audio 60k Format: WEBM"
else echo "Download Format: " $TYPEFORMAT
fi
youtube-dl -f $TYPEFORMAT $run_id

done

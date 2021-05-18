#!/bin/bash
if [ "$1" == "auto" ]; then
	auto=1
else
	auto=0
fi
old_md5=""
while [ 1 == 1 ]; do
	md5=$(md5sum output.mid)
	[ $auto == 1 ] && ./ccgmusic
  if [ "$md5" != "$old_md5" -o $auto == 1 ]; then
  	old_md5="$md5"
  	timidity output.mid
  	sleep 0.1
    echo "Waiting..."
  else
    sleep 1
  fi
done

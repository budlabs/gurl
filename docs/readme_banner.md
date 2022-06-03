
Imagine you have a URL to a podcast episode.  You
want to download the file,  edit the filename in
dmenu before saving, automatically add thumbnail
and albumart add a notification,  maybe convert
the audio to mp3.  The whole process consist of
functions that may or may not be useful for other
links,  (images, video, torrent links etc).  But
it gets hard to maintain if all functions are
scattered around the filesystem. Not to mention,
keeping notifications and menus consistent across
the scripts.  You also want to have the pattern
matching close to the scripts so to speak,  but
maybe not **in** the scripts..  

**gurl** tries to solve this by using a special
directory for all patterns, commands and common
dirthack utilities one creates to handle
URLs. 

The **gurl** function itself is just \~30 lines of
bash and awk,  but it sets a nice stage for
managing and creating URL handlers.

# gurl - ganoo slash URL handler and plumber framework 

Imagine you have a URL to a podcast episode.  You want to
download the file,  edit the filename in dmenu before
saving, automatically add thumbnail and albumart add a
notification,  maybe convert the audio to mp3.  The whole
process consist of functions that may or may not be useful
for other links,  (images, video, torrent links etc).  But
it gets hard to maintain if all functions are scattered
around the filesystem. Not to mention,  keeping
notifications and menus consistent across the scripts.  You
also want to have the pattern matching close to the scripts
so to speak,  but maybe not **in** the scripts..  

**gurl** tries to solve this by using a special directory
for all patterns, commands and common dirthack utilities one
creates to handle URLs.  

The **gurl** function itself is just \~30 lines of bash and awk,  but it sets a nice stage for managing and creating URL handlers.

## installation

If you use **Arch Linux** you can get **gurl** from
[AUR](https://aur.archlinux.org/packages/gurl/).  

Use the `make(1)` to do a systemwide installation of both
the script and the manpage.  

(*configure the installation destination in the Makefile,
if needed*)

```
$ git clone https://github.com/budlabs/gurl.git
$ cd gurl
# make install
$ gurl -v
gurl - version: 2020.03.26.3
updated: 2020-03-26 by budRich
```


usage
-----

When **gurl** is executed it will match it's first
argument, (URL) against rules defined in files named `match`
located in **MATCHERS_DIR** (*defaults to ~/.config/gurl*)
including subdirectories. The syntax for the rules are as
follows:
```  
ACTION: PATTERN

# blank lines and lines starting with sharp (#)
# will be ignored.
ACTION2: PATTERN2
```


*ACTION* is a command either in **PATH** or relative to the
*match file*.  
*PATTERN* is a `awk(1)` compatible regular expression.

All arguments passed to **gurl** will be forwarded to
*ACTION*. If *ACTION* is a executable file in
**MATCHERS_DIR**, the directory of the *ACTION* will be the
actions working directory, **MATCHERS_DIR/\_lib** will be
added to **PATH**.  

If no match is found, *ACTION* is set to **MATCHERS_DIR/default**.


options
-------

```text
gurl [--matchers-dir|-d DIR] URL [ARG...]
gurl --help|-h
gurl --version|-v
```


`--matchers-dir`|`-d` DIR  
Override the environment variable **MATCHERS_DIR** with
DIR.

`--help`|`-h`  
Show help and exit.

`--version`|`-v`  
Show version and exit.

examples
--------

**gurl** will add the following filestructure the first
time it is invoked. No files or directories are mandatory,
but patterns must be declared in files named `match` . Be
sure to set scripts to be executable. (bash scripts are used
in the example, but any executable files will work).  

```
~/.config/gurl
  _lib/
    message.sh
    ynp.sh
    cb.sh
  github/
    match
    repo.sh
    ghfile.sh
    assets/
      vars
  youtube/
    youtube.sh
  .last
  match
  default
```


`$ gurl https://github.com/budlabs/gurl` - this will match
the second pattern in `github/match` and execute
`github/repo.sh`. Notice how the path to the action is
relative to match file it is declared in. arguments (the URL
in this case) passed to **gurl** will get saved to `.last`,
which can be handy when writing the patterns.  

`~/.config/gurl/github/match`
``` text
ghfile.sh: (http[s]?://)?.*github[.]com.*/(blob|raw)/.+
repo.sh:   (http[s]?://)?.*github[.]com/[^/]+/[^/]
```


executables in `_lib/` can be executed without specifying
the path. And files (assets/vars) can be sourced using a
path relative to the scriptfile.

`~/.config/gurl/github/repo.sh`
``` bash
#!/bin/bash

source assets/vars

[[ $1 =~ (http[s]?://)?.*github[.]com/([^/]+/[^/]+) ]] \
    && repo=${BASH_REMATCH[2]}

prompt="clone $repo to $clone_dir/${repo#*/}? "

[[ $(ynp.sh "$prompt") = yes ]] && message.sh "you answered yes"
```


`~/.config/gurl/github/assets/vars`
``` bash
clone_dir=$HOME/git/clones
```


`~/.config/gurl/_lib/message.sh`
``` bash
#!/bin/bash
notify-send "$*"
```


`~/.config/gurl/_lib/ynp.sh`
``` bash
#!/bin/bash
echo -e "yes\nno" | dmenu -p "$1"
```


`~/.config/gurl/_lib/cb.sh`
``` bash
#!/bin/bash
echo -n "$1" | xclip -sel c
```


`~/.config/gurl/github/ghfile.sh`
``` bash
#!/bin/bash
message.sh "$1 is a github file, download link in clipboard"

cb.sh "${1/blob/raw}"
```


`~/.config/gurl/youtube/youtube.sh`
``` bash
#!/bin/bash
message.sh "a youtube link!"
```


`~/.config/.last`
``` text
https://github.com/budlabs/gurl
```


`~/.config/gurl/default`
``` bash
#!/bin/bash
echo no pattern matching: "$1"
```


`~/.config/gurl/match`
``` text
youtube/youtube.sh: (http[s]?://)?.*youtube[.]com.*
notify-send: (http[s]?://)?.*google[.]com.*
```


notice how commands can be used for actions (`notify-send`).  
## updates

#### 20.03.26.1

Initial release.


## license

**gurl** is licensed with the **BSD-2-CLAUSE license**



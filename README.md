# Dragon's Breath #

A MacOS menu bar notifier for 
[Dragon Go Server](http://www.dragongoserver.net/).

## Features ##

* Shows a visible indicator when you have moves to make.
* Keeps track of which games you've looked at, and turns off the indicator
once you've looked at all of those awaiting moves (until a new move is needed).
* Lets you jump directly to the game page for a waiting move.
* Refreshes automatically every five minutes (rather than once an hour, which
is the delay for DGS email notifications), or whenever you ask for a refresh.
* Checks for new moves as soon as your computer wakes from sleep.
* Provides shortcuts to other commonly-visited DGS pages.

## Status ##

The app is now fully functional, other than setting your password. If you want
to use it, and have a copy of XCode 4 to compile it, create DBPassword.h and
add these lines to it:

    #define DRAGON_AUTH_INFO @"userid=[NICKNAME]&passwd=[PASSWORD]"

The "Running Games" link won't work at the moment.

That file is in .gitignore; don't push it up to GitHub. With that file added,
though, you can compile and run the app.

- Marc Hedlund, marc@precipice.org

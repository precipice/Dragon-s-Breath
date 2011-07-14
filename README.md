# Dragon's Breath #

A MacOS menu bar notifier for 
[Dragon Go Server](http://www.dragongoserver.net/).

## Status ##

The app is now fully functional, other than setting your password. If you want
to use it, and have a copy of XCode 4 to compile it, create DBPassword.h and
add these lines to it:

    #define DRAGON_AUTH_INFO @"userid=[NICKNAME]&passwd=[PASSWORD]"
    #define DRAGON_USERID @"uid=[USER ID NUMBER]"

That file is in .gitignore; don't push it up to GitHub. With that file added,
though, you can compile and run the app.

- Marc Hedlund, marc@precipice.org

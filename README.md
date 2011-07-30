# Dragon's Breath #

A MacOS X menu bar notifier for 
[Dragon Go Server](http://www.dragongoserver.net/) messages.

## Features ##

* Shows a menu bar indicator when you have moves to make (similar to the
  Twitter app's blue bird, but with a mini Go board and no blue).
* Supports [Growl](http://growl.info/) notifications for new messages.
* Refreshes every five minutes (rather than once an hour, which is the delay
  for DGS email notifications), or whenever you ask for a refresh. Use less
  time for each move!
* Lets you jump directly to the game page for a waiting move.
* Launches automatically on login.
* Provides shortcuts to other commonly-visited DGS pages.

## Status ##

The initial stable release is finished and I've submitted it to the Mac App
Store (it's in review). If you'd like to give it a try, you can 
[download v1.0.0](https://github.com/downloads/precipice/Dragon-s-Breath/Dragon-s-Breath-v1.0.0.zip),
drop it in your Applications folder, and run it. Feedback would be great.

## Thanks ##

Dragon's Breath uses code from other developers:

* [Growl](http://growl.info/)
* [MWFeedParser](https://github.com/mwaterfall/MWFeedParser)
* [RegexKitLite](http://regexkit.sourceforge.net/RegexKitLite/)
* [LaunchAtLoginController](https://github.com/Mozketo/LaunchAtLoginController)

Please see 
[LICENSE.txt](https://github.com/precipice/Dragon-s-Breath/blob/master/LICENSE.txt)
for license statements for each of these projects and for Dragon's Breath
itself (which uses the Apache License, v2.0). Thanks to all of the above for
making their code available!

- Marc Hedlund, marc@precipice.org

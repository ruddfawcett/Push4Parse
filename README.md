Push4Parse
==========
> Push4Parse is an elegant notification composer for http://parse.com, a service that allows you to send push notifications to your iOS apps easily.  Push4Parse makes it easy to send notifications to your app on the go with a fun, easy to use UI and simple application adding process.  The app is available on the [App Store](https://appsto.re/i6FG3gt).  

## Screenshots
<img src='http://i.imgur.com/OlbIqM5.png' />

## Building & Configuration

### The Backend
#### Hosted Domain

To run on a domain, just upload the `Push4Parse.php` file found in the **php** folder.

#### Locally

Open up Terminal and run

```
cd Push4Parse/php
php -S localhost:8080
```

Depending on the method you did above, you will now either be able to locate the file at [https://domain.com/Push4Parse.php]() or at [localhost:8080/Push4Parse.php]().

===

### The App
##### You've used CocoaPods before
Run `pod install` in the **ios** folder just to be safe.


##### New to CocoaPods
Oepn up Terminal and run 

```
gem install cocoapods
cd Push4Parse/ios
pod install
```
See [CocoaPods](http://cocoapods.org) for more information on using CocoaPods in your future projects.

===

### Changes

Having done all of the above, you now need to make a few changes in the actual code.  

Open up the .xcworkspace and in `SendNotificationViewController.m` on line **96**, change the URL to your `Push4Parse.php` file path.  Don't forget to modify the `postPath` on line **102** either.

If you have any errors, or are having trouble with the above, [open an issue](https://github.com/trigon/Push4Parse/issues).

## License

The MIT License (MIT)

Copyright (c) 2013 Trigon, LLC.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# LaunchAtLoginHelper

When creating a sandboxed app, `LSSharedFileListInsertItemURL` can no longer be used to launch the app at startup. Instead `SMLoginItemSetEnabled` should be used with a helper app inside the main app’s bundle, the sole job of which is to launch the main app. **LaunchAtLoginHelper** is a ready-made helper app. It is designed to be as easy as possible to integrate into the main app to allow it to launch at login when sandboxed.

A lot of research went into this helper app. For example [Apple’s docs](http://developer.apple.com/library/mac/#documentation/Security/Conceptual/AppSandboxDesignGuide/DesigningYourSandbox/DesigningYourSandbox.html#//apple_ref/doc/uid/TP40011183-CH4-SW3) state that `LSRegisterURL` should be used to register the helper app, however this never seemed to work and after further digging it turns out this is a [typo in the docs](https://devforums.apple.com/message/647212#647212). Many examples I found online used `NSWorkspace launchApplication:` to launch the main app, however this was blocked by sandboxing so a url scheme is used instead.

**LaunchAtLoginHelper** calls the main app’s scheme to launch the app with `launchedAtLogin` as the `host` so the main app can know if it has been launched at login. For example [Play by Play](http://playbyplayapp.com) uses this to hide the app if it was launched at login.

This project contains a [sample app](https://github.com/kgn/LaunchAtLoginHelper/tree/master/LaunchAtLoginSample) to demonstrate how the main app should be configured and how to setup a checkbox to enable and disable launching at login.

## How to use

First download or even better submodule **LaunchAtLoginHelper**. To clone the repository as a submodule use the following commands:

```
$ cd <main_app_project>
$ git submodule add https://github.com/kgn/LaunchAtLoginHelper.git External/LaunchAtLoginHelper
```

### 1. URL Type

**LaunchAtLoginHelper** uses a url scheme to launch the main app, if the main app doesn’t have a url scheme yet, you will have to add one.

![](http://kgn.github.com/content/launchatlogin/url_scheme.png)

This will add a CFBundleURLTypes key and the correct hierarchy of child keys to your app’s `Info.plist`.

### 2. setup.py

There is some setup missing in a fresh repo, that is specific to your instance of the helper app. To generate the necessary files run the `setup.py` python script and pass in the url scheme to launch the main app and the bundle identifier of the helper app, this is usually based of of the bundle identifier of the main app but with *Helper* added onto the end.

```
$ cd LaunchAtLoginHelper
$ python setup.py <main_app_url_scheme> <helper_app_bundle_identifier>
```

For the sample code the above will look like this:

```
$ cd LaunchAtLoginHelper
$ python setup.py launchatloginsample com.InScopeApps.ShellTo.LaunchAtLoginHelper
```

This will complete the setup of your custom `LaunchAtLoginHelper-Info.plist` which is created for the helper app with it’s custom bundle identifier filled in.

### 3. Adding to your main project

Once these files are generated it’s time to add **LaunchAtLoginHelper** to the main app. Drag `LaunchAtLoginHelper.xcodeproj`, `LLManager.h`, and `LLManager.m` to the main app’s project.

![](http://kgn.github.com/content/launchatlogin/drag_drop_file.png)

Next go to the *Build Phases* for the main app and add **LaunchAtLoginHelper** as a *Target Dependency* and create a new *Copy Files Build Phase*. Set the *Destination* of this build phase to `Wrapper` and the *Subpath* to `Contents/Library/LoginItems`.

![](http://kgn.github.com/content/launchatlogin/build_phases.png)

You also have to set `LLHelperBundleIdentifier` in the main app's Info.plist so using `LLManager` will be able to discover the helper app. 

Lastly add `ServiceManagement.framework` to the main app.

Once this is done use `LLManager` to enable and disable launching at login! [**LaunchAtLoginSample**](https://github.com/kgn/LaunchAtLoginHelper/blob/master/LaunchAtLoginSample/LLAppDelegate.m) shows how to hook this up to a checkbox.

``` obj-c
#import "LLManager.h"

[LLManager launchAtLogin] // will the app launch at login?
[LLManager setLaunchAtLogin:YES] // set the app to launch at login
```

## Failure Case

This version of LLManager will send a notification if setting `launchAtLogin` failed. To test this, remove the `Library` folder from the `Contents` folder of your app.

## Bindings

The `LLManager` class supports KVO and Cocoa Bindings. This allows for a completely code-free implementation of this class. To get started, open the Interface Builder document in which you plan to create a login toggle. 

Drag a generic `NSObject` from the Utilities pane, and drop it onto your canvas. Select the newly created object, and open the Identity inspector tab in the Utilities pane. Change the class from `NSObject` to `LLManager`. You can optionally rename this instance to `Launch Manager` by setting its label.

If you want to receive failure notifications in your app, you can add an entry to the “User Defined Runtime Attributes” of your `Launch Manager`:

* Key Path: notifyIfSetLaunchAtLoginFailed
* Type: Boolean
* Value: (checked)

Now, select your login toggle (checkbox) and open the Bindings inspector in the Utilities pane. Expand `Value`, check the “Bind to”, and select the name of the `LLManager` object you created earlier. Set the key path to `launchAtLogin`. You’re done!

## Notes

Apple’s [Daemons and Services Programming Guide](http://developer.apple.com/library/mac/#documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLoginItems.html#//apple_ref/doc/uid/10000172i-SW5-SW1) tells us the following under the heading “Adding Login Items Using the Service Management Framework”:

> If multiple applications (for example, several applications from the same company) contain a helper application with the same bundle identifier, only the one with the greatest bundle version number is launched. Any of the applications that contain a copy of the helper application can enable and disable it.

So we should make sure that our helper will have a monotonically increasing *bundle version number*. This is especially important for beta testing, where multiple bundles with the same bundle identifier may be available and the *version number* is the only thing differentiating them.

You can use something like this bash script fragment:

    echo -n "${TARGET_BUILD_DIR}/${CONTENTS_FOLDER_PATH}/Library/LoginItems/LaunchAtLoginHelper.app/Contents/Info.plist" \
        | xargs -0 /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $REVISION"
    echo -n "${TARGET_BUILD_DIR}/${CONTENTS_FOLDER_PATH}/Library/LoginItems/LaunchAtLoginHelper.app/Contents/Info.plist" \
        | xargs -0 /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $VERSION_NUM"

You will have to set $REVISION and $VERSION_NUM beforehand, of course. `PlistBuddy` is part of any Xcode install. A good place to do this is a script that extracts version information from the current git tag and writes it to your app’s `Info.plist`.

Warning: the above will invalidate your launch helper’s signature as you are modifying the data that was signed while it was built as a prerequisite for building your main app. To fix this, its needs to be signed again. A convenient way to do this is [this script](http://stackoverflow.com/a/11284404). 

---

Special thanks to [Curtis Hard](http://www.geekygoodness.com) for offering some much needed advice on this project.

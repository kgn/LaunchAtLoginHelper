import sys, os
import plistlib

urlScheme = sys.argv[1]
bundleIdentifier = sys.argv[2]

directory = os.path.dirname(os.path.abspath(__file__))

infoPlistOutput = os.path.join(directory, 'LaunchAtLoginHelper/LaunchAtLoginHelper-Info.plist')
infoPlist = plistlib.readPlist(os.path.join(directory, 'LaunchAtLoginHelper/LaunchAtLoginHelper-InfoBase.plist'))

infoPlist['CFBundleIdentifier'] = bundleIdentifier
infoPlist['LLURLScheme'] = urlScheme
plistlib.writePlist(infoPlist, infoPlistOutput)

There are two files missing from this repo that are specific to your instance of the helper app. To generate these files run the `setup.py` python script and pass in the url scheme to launch the main app and the bundle identifier of the helper app, this is usually based of of the bundle identifier of the main app but with *Helper* added onto the end.

```
python setup.py <main_app_url_scheme> <helper_app_bundle_identifier>
```

Special thanks to [Curtis Hard](http://www.geekygoodness.com) for offering some much needed advice on this project.
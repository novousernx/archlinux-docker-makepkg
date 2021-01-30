Usage locally.
-------------

```
docker run -v $PWD:/pkg whynothugo/makepkg
```

# Or export the built package file to the workding directory.
```
docker run --rm --name build -e EXPORT_PKG=1 -v $PWD:/pkg whynothugo/makepkg
```

Extra details.
-------------

* `base-devel` is preinstalled.
* All `depends` will be installed (including AUR packages using [yay](https://github.com/Jguer/yay)).
* GPG keys used to verify signatures are auto-fetched.

[![Build Status](https://travis-ci.com/skycoin/skycoin-lite.svg?branch=master)](https://travis-ci.com/skycoin/skycoin-lite)

# Skycoin Liteclient

This repository contains a liteclient for Skycoin written in Go. At the moment it is only used to compile
an [Android Archive](https://developer.android.com/studio/projects/android-library.html)
and a JS library with [gopherjs](https://github.com/gopherjs/gopherjs).

Skycoin Liteclient supports go1.10+.

## Compiling Android aar and jar

For the compilation process to Android Archive, we use [Go Mobile](https://github.com/golang/mobile).

```bash
$ gomobile bind -target=android github.com/skycoin/skycoin-lite/mobile
```

## Compile javascript library

For the compilation process to javascript library, we use [gopherjs](https://github.com/gopherjs/gopherjs).

To compile the library use `make build-js` or `make build-js-min` (if you want the final file to be minified).
After compiling, the main.js and main.js.map files will be created/updated in the root of the repository.

## Development

The javascript library is created starting from [gopher/main.go](gopher/main.go). The Android library is
created starting from [mobile/api.go](mobile/api.go).

### Running tests

gopherjs tests can be run with

```sh
make test-js
```

The tests require node syscall support installed, see install instructions at
https://github.com/gopherjs/gopherjs/blob/master/doc/syscalls.md#nodejs-on-linux-and-macos

Note that you can't use the vendored gopherjs for this, because the gopherjs/node-syscall package
can't be vendored by dep. You'll have to install gopherjs to your `GOPATH` with `go get`.

To enable stacktraces, install source maps:

```sh
npm install --global source-map-support
```

and make sure `NODE_PATH` is set to the value of `npm root --global` in your environment.

### Formatting

All `.go` source files should be formatted `goimports`.  You can do this with:

```sh
make format
```

### Code Linting

Install prerequisites:

```sh
make install-linters
```

Run linters:

```sh
make lint

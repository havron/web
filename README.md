# min
[![Build
Status](https://travis-ci.org/havron/min.svg?branch=master)](https://travis-ci.org/havron/min)
[![Website](https://img.shields.io/website-up-down-green-red/http/shields.io.svg)](https://min.havron.dev)

The [master branch](https://github.com/havron/min/tree/master) has the source
code, while the [gh-pages branch](https://github.com/havron/min/tree/gh-pages)
is filled with the contents that visitors [see](https://min.havron.dev).

The source code is compiled with [Hugo](https://gohugo.io/), and the theme is
based on [Cocoa Enhanced](https://github.com/mtn/cocoa-eh-hugo-theme), with
some modifications.

When there is a new commit to the source code, [Travis
CI](https://travis-ci.org) spins up a server to run [this
script](/.travis.yml), which compiles the source code and pushes the results to
the [gh-pages branch](https://github.com/havron/min/tree/gh-pages). [GitHub
Pages](https://pages.github.com/) then hosts the contents of
[gh-pages](https://github.com/havron/min/tree/gh-pages) at
[https://min.havron.dev](https://min.havron.dev).

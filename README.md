# Sam's personal webpages
[![Build
Status](https://travis-ci.org/havron/min.svg?branch=master)](https://travis-ci.org/havron/min)
[![Website](https://img.shields.io/website-up-down-green-red/http/shields.io.svg)](https://havron.dev)

## About
This repository contains all of the source code for my personal website. The
code is compiled into web pages (HTML, CSS, JS) with
[Hugo](https://gohugo.io/), and the theme is based on [Cocoa
Enhanced](https://github.com/mtn/cocoa-eh-hugo-theme), with some modifications.
There are [a lot of nice
benefits](https://davidwalsh.name/introduction-static-site-generators) to
making a website this way.

## Editing
When editing the content of my pages with a text editor, I can see how the
website will look by running `make server` in a terminal to start Hugo's (offline)
development server, and then navigating to `localhost:1313` in a web browser to
view and interact with the pages locally before publishing them anywhere
online.

## Deploying (Hosting)
My web pages are accessible at <https://www.cs.cornell.edu/~havron/>,
<https://havron.xyz>, and <https://havron.dev>. Each of these URLs
serve the same content, but they are hosted with different
cloud providers.

When I'm done editing the source code, I run the command `make commit-deploy`
to push my local changes to this repository, and also automatically deploy them
to each of the above URLs. The [Makefile](./Makefile) contains more details on
how this is done.  If you would like to deploy your own web pages, I recommend
going with the approach I used for `havron.dev` (with GitHub Pages).  It's free
and the least hassle if you are not using a personal server or one associated
with your school or workplace.

### havron.dev (recommended way to host)
When there is a new commit pushed to this repository, [Travis
CI](https://travis-ci.org) spins up a server to run [this
script](/.travis.yml), which compiles the source code and pushes the results to
the [havron.github.io](https://github.com/havron/havron.github.io). [GitHub
Pages](https://pages.github.com/) then hosts the contents of that repo at
[https://havron.dev](https://havron.dev). GitHub Pages uses a content delivery
network to ensure fast and reliable access to the website from anywhere in the world.

### cs.cornell.edu
Hosted by Cornell's [COECIS IT Service Group](https://it.cornell.edu/coecis).
The `cs.cornell.edu` target in the [Makefile](./Makefile) builds the content
and then copies/syncs it to the internal Cornell CS webserver under my personal
directory using [rsync](https://rsync.samba.org/).

### havron.xyz
Hosted by [Amazon Web Services](https://aws.amazon.com). The `havron.xyz`
target in the [Makefile](./Makefile) builds the content and then copies/syncs
it to [S3](https://aws.amazon.com/s3/).
[Cloudfront](https://aws.amazon.com/cloudfront/) then distributes the contents
of my S3 bucket to make a content delivery network.

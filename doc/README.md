# SSH Labs Documentation

This directory contains the documentation of the SSH labs.

The documentation is available on https://sshlabs.compass-security.training.

[![Build and Publish Documentation](https://github.com/emanuelduss/ssh-labs/actions/workflows/docs.yml/badge.svg)](https://github.com/emanuelduss/ssh-labs/actions/workflows/docs.yml)

You can build the static documentation site from the Markdown files yourself
using Zensical.

## Zensical

Install Zensical:

```bash
uv tool install zensical
```

Build the site:

```
zensical build
```

Open the file `./site/index.html` to open the documentation.

You can also start a webserver and directly serve the documentation pages:

```bash
zensical serve
```

## Docker

You can also use the build script which uses the Zensical Docker container:

```bash
docker run --rm -it -v ${PWD}:/docs zensical/zensical build
```

Serve via Docker container:

```bash
docker run -p 8000:8000 --rm -it -v ${PWD}:/docs zensical/zensical serve --dev-addr 0.0.0.0:8000
```

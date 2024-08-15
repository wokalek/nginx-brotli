## About

This is a super simple and easy to read nginx docker alpine-based image.

## What's inside

- Only default [nginx modules](https://nginx.org/en/docs/)
- [`ngx_brotli`](https://github.com/google/ngx_brotli) — brotli algorithm compression
- `git` apk installed
- Ports `80` and `443` are exposed by default

## Why?

This is the smallest and most up-to-date nginx-brotli image you can find.

The most popular `fholzer/nginx-brotli` with 1 million pools is 13.96 MB, `wokalek/nginx-brotli` is **5.28 MB** (compare fholzer/nginx-brotli:1.24.0 and wokalek/nginx-brotli:1.27.1).

Alpine! Everyone loves alpine. Other images you may find use different base images.

And of course this dockerfile can be perfect for your nginx build with your modules! Take a look.

## How to use this image

Pull image from Docker Hub:

```bash
docker pull wokalek/nginx-brotli
```

or from GitHub Packages:

```bash
docker pull ghcr.io/wokalek/nginx-brotli
```

You can use this image just like the [official nginx](https://hub.docker.com/_/nginx).

Check out the available tags.

## HTTP3/QUIC

If you are looking for HTTP3/QUIC support, there is an [http3/quic build using OpenSSL](https://github.com/wokalek/nginx-brotli/tree/http3).

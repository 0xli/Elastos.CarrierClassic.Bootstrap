# libevent (bundled build)

This tree builds **libevent 2.1.8-stable** from the upstream tarball via CMake `ExternalProject`, with local patches applied before `./configure`.

## Patches (`libevent.patch`)

### 1. LibreSSL OpenSSL compatibility

Adds a small guard in `openssl-compat.h` so LibreSSL builds work with the bundled OpenSSL compatibility shims (`BIO_get_init`).

### 2. `arc4random_addrandom` and modern glibc (link fix)

**Symptom:** `make` fails while linking samples (e.g. `sample/dns-example`) with:

`undefined reference to 'arc4random_addrandom'`

**Cause:** In 2.1.8, when configure detects libc **`arc4random()`**, it defines `EVENT__HAVE_ARC4RANDOM` and uses the system RNG. The helper **`evutil_secure_rng_add_bytes()`** still called **`arc4random_addrandom()`**, which is not part of the portable libc API and is not provided by current **glibc** (see upstream [libevent#615](https://github.com/libevent/libevent/issues/615)).

**Change:** Only call `arc4random_addrandom()` in the `#else` branch (bundled `arc4random.c`). When `EVENT__HAVE_ARC4RANDOM` is set, the extra “add entropy” path is a no-op; this matches the direction of later libevent releases.

**Note:** A log line such as `python: not found` from `rpcgen_wrapper.sh` is unrelated; the build reuses generated files and continues. Install a `python` binary if you want that step to run without warnings.

## Rebuild after changing the patch

Remove the extracted source stamp so CMake re-downloads or re-patches, for example:

`rm -rf <build-dir>/deps/libevent/external/src/libevent-stamp`

Then configure and build again.

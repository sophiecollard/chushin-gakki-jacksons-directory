# Chushin Gakki Jacksons Directory

A directory of 90s and 00s high-end MIJ Jacksons.

## Build

### Development

Build the application with:

```
elm make src/Main.elm --output elm.js
```

On line 8 of `index.html`, set the script source to `elm.js`.

### Production

Build the application with:

```
elm make src/Main.elm --output elm.js --optimize
```

Minify the `elm.js` file with:

```
uglifyjs elm.js -o elm.min.js
```

(The above command requires installing uglify via `npm install -g uglify-js`.)

Finally, compress the resulting `elm.min.js` file with:

```
gzip -k elm.min.js
```

Upload the resulting `elm.min.js.gz` to a DigitalOcean space. Don't forget to enable the CDN feature on the bucket and to configure the object metadata to include the following headers:

  * `Content-Type: application/javascript`
  * `Content-Encoding: gzip`

On line 8 of `index.html`, set the script source to the URL to which `elm.min.js.gz` got uploaded.

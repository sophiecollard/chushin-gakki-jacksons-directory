# Chushin Gakki Jacksons Index

A database of 90s and 00s Jackson guitars made at the Chushin Gakki factory.

## Disclaimer

The "Jackson", "Jackson Stars", "Grover Jackson", "Team GJ" and "Charvel" brand names, logos, trademarks, and product designs referenced in this project are the exclusive property of Fender Musical Instruments Corporation (FMIC).

This project is not affiliated with or endorsed by FMIC. It is an independent, fan-made archive for informational purposes only.

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

## Licence

Copyright 2025 [Sophie Collard](https://github.com/sophiecollard).

Licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0) (the "License"); you may not use this software except in compliance with the License.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

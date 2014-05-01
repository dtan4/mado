# Mado
[![Gem Version](https://badge.fury.io/rb/mado.svg)](http://badge.fury.io/rb/mado)

Realtime [Github Flavored Markdown](https://help.github.com/articles/github-flavored-markdown) Preview with WebSocket

## Installation

Add this line to your application's Gemfile:

    gem 'mado'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mado

## Usage

```
Usage: mado [options] FILE
    -p, --port=VAL                   Port number (default: 8080)
    -a, --addr=VAL                   Address to bind (default: 0.0.0.0)
        --debug                      Debug mode
```

When you execute the following command, HTTP server starts on `http://0.0.0.0:8080` and WebSocket server starts separately.
You can check the preview of `README.md` on the browser.

Preview will be refreshed immediately along with your edition.

```sh
$ mado -p 8080 README.md
```

#### NOTE

WebSocket server uses **Port 8081** in spite of `-p` option.
Please be careful to port conflict.

## Contributing

1. Fork it ( https://github.com/dtan4/mado/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

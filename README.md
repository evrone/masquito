# Masquito

NOTICE: It's alpha for now.

This gem is for DNS masquerading for rubists. Everyone knows `Pow`, but what
I really don't like that it uses `node.js` to run ruby applications. What we need
sometimes is just run our app on the certain domain. Masquito allows you to do it,
you can create dns records in the way like Pow does, just creating symbolic
links in `.masquito` directory.

## Installation

Install it to your current or global gem set:

    gem install 'masquito'

And then execute:

    $ masquito start

## Usage

To set up a Rack app, just symlink it into ~/.masquito:

```
$ cd ~/.masquito
$ ln -s /path/to/my/rails/app
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

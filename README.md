# Masquito

This gem is for DNS masquerading for rubists. Everyone knows `Pow`, but what
I really don't like that it uses `node.js` to run ruby applications. Sometimes
we have to run our apps on the certain domain. Masquito allows you to do it,
you can create dns records in the similar Pow's way by creating symbolic links
in `.masquito` directory to your apps or just files because masquito doesn't
run rack applications just does dns masquerading.

## Installation

First of all, uninstall Pow if you have it installed.
I suppose you're on rbenv(we will add rvm support as soon as we can).

Install gem:

    $ gem install masquito

Run these commands:

    $ masquito daemon install
    $ sudo masquito resolver install

The first one installs masquito dns server as a daemon in your system which will
be started at each boot. This daemon will respond on dns queries from your
system. The second one registers dns resolver (`man 5 resolver` for more info)
for `.dev` domain. You have to run it with sudo because we must write config to
`/etc/resolver` path.

## Usage

Once you have installed masquito you can add domains to ~/.masquito

    $ cd ~/.masquito
    $ touch example

It will create for you example.dev domain and you can already ping and use it.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

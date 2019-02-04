# PLEASE NOTE, THIS PROJECT IS NO LONGER BEING MAINTAINED
# Masquito

This gem is for DNS masquerading for rubists. Everyone knows `Pow`, but what
I really don't like that it uses `node.js` to run Ruby applications. Sometimes
we have to run our apps on the certain domain. Masquito allows you to do it,
you can create dns records in the similar Pow's way by creating symbolic links
to your apps or just empty files in `.masquito` directory.

<a href="https://evrone.com/?utm_source=github.com">
  <img src="https://evrone.com/logo/evrone-sponsored-logo.png"
       alt="Sponsored by Evrone" width="231">
</a>

## Getting Started

### Prerequisites

Symbolic links were used by Pow in order to refer your application that will be
run automatically, since Masquito doesn't run applications and does just DNS
masquerading it's simplier to create just empty files. Check out another gem
[https://github.com/route/pump](https://github.com/route/pump) for full Pow's
replacement.

### Installation

First of all, uninstall Pow if you have it installed.
I suppose you're on rbenv (honestly I haven't checked rvm support).

Install gem:

    $ gem install masquito
    $ rbenv rehash

Run this:

    $ sudo masquito install

This command installs masquito server as a daemon that your system will start
every boot. This daemon will respond on DNS queries from your system and monitor
`~/.masquito` directory for newly created domains.

### Usage

Once you have installed masquito you can add domains to ~/.masquito

    $ cd ~/.masquito
    $ touch yoursite.com

It will create for you `yoursite.com` domain with the wild card for all
subdomains and you can already ping and use it for the development.

    $ ping yoursite.com
    PING yoursite.com (127.0.0.1): 56 data bytes
    64 bytes from 127.0.0.1: icmp_seq=0 ttl=53 time=1 ms

    $ ping host.sub.yoursite.com
    PING host.sub.yoursite.com (127.0.0.1): 56 data bytes
    64 bytes from 127.0.0.1: icmp_seq=0 ttl=53 time=1 ms

Run your favorite application server manually, open up your browser and fill in
address with port, that's all.

## Contributing

Please read [Code of Conduct](CODE-OF-CONDUCT.md) and [Contributing Guidelines](CONTRIBUTING.md) for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, 
see the [tags on this repository](https://github.com/evrone/masquito/tags). 

## Authors

* [Kir Shatrov](https://github.com/kirs) - *Initial work*

See also the list of [contributors](https://github.com/evrone/masquito/contributors) who participated in this project.

## License

This project is licensed under the [MIT License](LICENSE).

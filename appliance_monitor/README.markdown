## Overview

The attached repository is a Mojolicious web app built on top of DBIx::Class
and SQLite.  It's a framework and a couple of model classes, but has no
functionality implemented yet.  In order to work effectively on it, a Perl
development environment and a few libraries are needed.

## Setup

Ideally, you should run Mojolicious with Perl 5.20.x. If you have something
earlier on your machine, [Perlbrew](http://perlbrew.pl/) is very easy to
install and use. You can use Perlbrew to install Perl 5.20.x either permanently
on your system or in a local shell environment.

### Install cpanminus
If you don't have cpanminus, installing it will make your life much easier!

##### install to system perl (requires sudo access)
```
$ curl -L https://cpanmin.us | perl - --sudo App::cpanminus
```

_OR_

##### install to local (perlbrew) perl environment (sudo not needed)
```
$ curl -L https://cpanmin.us | perl - App::cpanminus
```

### Install required Perl packages
```
$ curl -L https://cpanmin.us | perl - Mojolicious DBIx::Class Devel::Cover File::Slurp SQL::Translator Test::DBIx::Class Test::Class
```

### Install git
Git is required for this assignment. If you don't have it installed for your OS,
see [Getting Started Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

#### Using git
If you're not already familiar with git, you'll need to at least know the basics. All you really
need for this challenge are three commands:

* ```git init```   - initializes a new local repository
* ```git add```    - adds file contents to git index for commit
* ```git commit``` - records changes to your local repository

You can also type ```git help``` at the command line for more information.
There are also some good online git tutorials. Feel free to take advantage of them.

## How To Contribute

See the `TODO` file.

## Returning Code to WhiteHat

When you are done, make sure *all* your changes are committed to your local repository,
then run the following:

```
$ git format-patch -o /tmp/$(whoami)-submission $(git rev-list --max-parents=0 HEAD)
$ cd /tmp && tar czvf $(whoami)-submission.tgz $(whoami)-submission
```

Send the resulting archive to us by email.



# Diff Influence

[![Build Status](https://travis-ci.org/metalels/diff_influence.svg?branch=master)](https://travis-ci.org/metalels/diff_influence)  
[![Gem Version](https://badge.fury.io/rb/diff_influence.svg)](https://badge.fury.io/rb/diff_influence)  

Search influence of git diff.

## Requirement ##

* Git ( support only git diff command. )
* Ruby ( support only Ruby 1.8.7 or later. )

## Installation ##

Add this line to your application's Gemfile:

```ruby
gem 'diff_influence', group: :development
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install diff_influence

## Usage ##

```
==============================================================================
[]: optional

Usage: diff-influence [Options]

 Options:

 -p --path path,path,...           path(s) to search file (default: app,lib)
 -e --ext  extension,extension,... extension(s) to search file (default: rb)
 -g --grep                         use grep command with OS
 -d --debug                        print debugging information to console

 Feature Options:

 -p --commit commit_id,commit_id   git commit id(s) uses diff (default: none)
 -o --output path                  to output file (default: STDOUT)
==============================================================================
```

## Authors ##

[metalels](https://github.com/metalels)

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

 -c --commit id1,id2,...          git commit id(s) uses diff (default: none)
 -d --dir  dir1,dir2,...          path(s) to search file (default: app,lib)
 -e --ext  ext1,ext2,...          extension(s) to search file (default: rb)
 -i --ignore method1,method2,...  ignore methods (default: new, index)
 -g --grep                        use grep command with OS
 -P --print                       print config values
 -D --debug                       print debugging information to console

 Feature Options:

 -o --output path                 to output file (default: STDOUT)
==============================================================================
```

## Permanent Options ##

Diff Influence laad _.diff-influece_ file in the root of your repository
or home.

```yaml
---
:commits: []
:search_directories:
- app
- lib
:search_extensions:
- rb
:ignore_methods:
- new
- index
:os_grep: false
:debug: false
```

You can display examples of _.diff-influence_ file definitions using the -P option.

## Authors ##

[metalels](https://github.com/metalels)

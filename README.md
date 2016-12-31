# fluent-plugin-add, a plugin for [Fluentd](http://fluentd.org) 
[![Build Status](https://travis-ci.org/yu-yamada/fluent-plugin-add.svg?branch=master)](https://travis-ci.org/yu-yamada/fluent-plugin-add)

[![Gem Version](https://badge.fury.io/rb/fluent-plugin-add.svg)](https://badge.fury.io/rb/fluent-plugin-add)

## Installation


    gem install fluent-plugin-add

## Configration

### AddOutput

    <match test.**>
      @type add
      add_tag_prefix debug
      uuid true # optional 
      <pair>
        hoge moge
        hogehoge mogemoge
      </pair>
    </match>


### Assuming following inputs are coming:
    test.aa: {"json":"dayo"}
### then output becomes as belows
    debug.test.aa: {"json":"dayo", "hoge":"moge","hogehoge":"mogemoge","uuid":"427037E7-235B-4F6C-9975-15AAC75E56C5"}

### AddFilter

    <filter test.**>
      @type add
      uuid true # optional
      <pair>
        hoge moge
        hogehoge mogemoge
      </pair>
    </filter>


### Assuming following inputs are coming:
    test.aa: {"json":"dayo"}
### then output bocomes as belows
    debug.test.aa: {"json":"dayo", "hoge":"moge","hogehoge":"mogemoge","uuid":"427037E7-235B-4F6C-9975-15AAC75E56C5"}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright
    Copyright (c) 2013 yu-yamada

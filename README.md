# fluent-plugin-add, a plugin for [Fluentd](http://fluentd.org) 


## Installation


    gem install fluent-plugin-add

## Configration

### AddOutput

    <match test.**>
      type add
      add_tag_prefix debug
      <pair>
        hoge moge
        hogehoge mogemoge
      </pair>
    </match>


### Assuming following inputs are coming:
    test.aa: {"json":"dayo"}
### then output bocomes as belows
    debug.test.aa: {"json":"dayo", "hoge":"moge","hogehoge":"mogemoge"}

### AddFilter

    <filter test.**>
      type add
      <pair>
        hoge moge
        hogehoge mogemoge
      </pair>
    </filter>


### Assuming following inputs are coming:
    test.aa: {"json":"dayo"}
### then output bocomes as belows
    debug.test.aa: {"json":"dayo", "hoge":"moge","hogehoge":"mogemoge"}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright
    Copyright (c) 2013 yu-yamada

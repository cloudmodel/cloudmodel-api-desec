# CloudModel::Api::Desec

![RSpec](https://github.com/cloudmodel/cloudmodel-api-desec/workflows/RSpec/badge.svg)
![CodeQL](https://github.com/cloudmodel/cloudmodel-api-desec/workflows/CodeQL/badge.svg)

Support for Desec DNS API in [CloudModel](https://github.com/cloudmodel/cloudmodel).

## Usage
Adds following ablities to CloudModel:

* Change Desec server DNS on changing AddressResolution

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'cloudmodel-api-desec'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install cloudmodel-api-desec
```

## Configuration
Set your deSEC API tokens in `config/initializers/cloud_model_config.rb`, keyed
by DNS zone (domain). **Keep tokens out of the repo** — read them from a secret
store (Rails encrypted credentials or ENV), never inline:

```ruby
CloudModel.setup do |config|
  config.api.desec.tokens =
    (Rails.application.credentials.dig(:api, :desec, :tokens) || {}).to_h.transform_keys(&:to_s)
end
```

The credentials hold, per zone:

```yaml
api:
  desec:
    tokens:
      example.com: your-desec-token
      example.net: another-token
```

| Option | Purpose |
| --- | --- |
| `config.api.desec.tokens` | Hash of `zone => deSEC API token`. `token_for(zone)` resolves the token used to update that zone's records. |

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

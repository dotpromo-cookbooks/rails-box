dotpromo-rails-box Cookbook
===========================
[![Build Status](https://travis-ci.org/dotpromo-cookbooks/rails-box.svg?branch=master)](https://travis-ci.org/dotpromo-cookbooks/rails-box)
Rails app box cookbook

Requirements
------------
#### packages

- `dotpromo-ruby-box`
- `dotpromo-postgresql-box`
- `database`
- `openssl`
- `nginx`
- `redisio`
- `java`
- `runit`
- `simple_iptables`

Attributes
----------

#### dotpromo-rails-box::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['dotpromo-rails-box']['app_name']</tt></td>
    <td>String</td>
    <td>Name of application</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['dotpromo-rails-box']['app_dir']</tt></td>
    <td>String</td>
    <td>Application home folder</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['dotpromo-rails-box']['install_redis']</tt></td>
    <td>Boolean</td>
    <td>Need install redis or not</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['dotpromo-rails-box']['install_java']</tt></td>
    <td>Boolean</td>
    <td>Need install java or not</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['dotpromo-rails-box']['use_runit']</tt></td>
    <td>Boolean</td>
    <td>Need install runit and link user's service dir for application</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['dotpromo-rails-box']['sock_file']</tt></td>
    <td>String</td>
    <td>Sock file name inside `shared/tmp/sockets/` application folder</td>
    <td><tt>puma.sock</tt></td>
  </tr>
</table>

Usage
-----
#### dotpromo-rails-box::default
Just include `dotpromo-rails-box` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[dotpromo-rails-box]"
  ]
}
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Alexander Simonov <alex@simonov.me>

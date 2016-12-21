class profile::metrics::collectd {

  class { '::collectd':
    purge_config => true,
    interval     => '5',
  }

  include ::collectd::plugin::cpu
  #include ::collectd::plugin::disk
  include ::collectd::plugin::memory
  include ::collectd::plugin::interface
  include ::collectd::plugin::df

  $monitoring_node = lookup('profile::metrics::monitoring_node',{
    'default_value' => false
  })
  notice "monitoring_node: ${monitoring_node}"

  if $monitoring_node {
    collectd::plugin::write_graphite::carbon {'my_graphite':
      graphitehost   => $monitoring_node,
      graphiteport   => 2003,
      graphiteprefix => '',
      protocol       => 'tcp'
    }
  }

}

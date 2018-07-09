class trilio::contego (
    $tvault_version                       = undef,
    $redhat_openstack_version             = '10',
    $tvault_virtual_ip                    = undef,
    $nova_conf_file			  = '/etc/nova/nova.conf',
    $nova_dist_conf_file		  = '/usr/share/nova/nova-dist.conf',
    $backup_target_type                   = 'nfs',   ##Other values: swift, s3
    $nfs_shares				  = undef,
    $nfs_options			  = 'nolock,soft,timeo=180,intr',
    $swift_auth_version                   = 'tempauth',          ## Other values: keystone_v2, keystone_v3
    $swift_auth_url                       = undef,
    $swift_tenant                         = undef,
    $swift_username                       = undef,
    $swift_password                       = undef,
    $swift_domain_id                      = undef,
    $swift_domain_name                    = 'default',
    $swift_region_name                    = undef,
    $s3_type                              = 'amazon_s3',         ##Other values: ceph_s3, minio_s3
    $s3_accesskey                         = undef,
    $s3_secretkey                         = undef,
    $s3_region_name                       = undef,
    $s3_bucket                            = undef,
    $s3_endpoint_url                      = undef,
    $s3_ssl_enabled                       = 'False',
    $s3_signature_version                 = 's3v4',
) {


    $contego_user                         = 'nova'
    $contego_group                        = 'nova'
    $contego_conf_file                    = "/etc/tvault-contego/tvault-contego.conf"
    $contego_groups                       = ['kvm','qemu','disk']
    $vault_data_dir                       = "/var/triliovault-mounts"
    $vault_data_dir_old                   = "/var/triliovault"
    $contego_dir                          = "/home/tvault"
    $contego_virtenv_dir                  = "${contego_dir}/.virtenv"
    $log_dir                              = "/var/log/nova"
    $contego_bin                          = "${contego_virtenv_dir}/bin/tvault-contego"
    $contego_python                       = "${contego_virtenv_dir}/bin/python"
    $config_files                         = "--config-file=${nova_dist_conf_file} --config-file=${nova_conf_file} --config-file=${contego_conf_file}"

  
    if $redhat_openstack_version == '9' {
           $openstack_release = 'mitaka'
    }
    elsif $redhat_openstack_version == '10' {
           $openstack_release = 'newton'
    }
    else {
           $openstack_release = 'premitaka'
    }


##Set object_store_ext

    if $backup_target_type == 'swift' {
        $contego_ext_object_store = "${contego_virtenv_dir}/lib/python2.7/site-packages/contego/nova/extension/driver/vaultfuse.py"
    }
    elsif $backup_target_type == 's3' {
        $contego_ext_object_store = "${contego_virtenv_dir}/lib/python2.7/site-packages/contego/nova/extension/driver/s3vaultfuse.py"

    }

    $version_numbers= split($tvault_version, '\.')
    $tvault_release = "${version_numbers[0]}.${version_numbers[1]}"
    class {'trilio::contego::validate': }
    class {'trilio::contego::install': }
    class {'trilio::contego::postinstall': }
    class {'trilio::contego::cgroup': }
    class {'trilio::contego::service': }

}

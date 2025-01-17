# == Class: barman
#
# This class installs Barman (Backup and recovery manager for Postgres).
#
# === Parameters
#
# [*user*] - The Barman user. Its value is set by 'settings' class.
# [*group*] - The group of the Barman user. Its value is set by 'settings'
#             class.
# [*ensure*] - Ensure that Barman is installed. The default value is 'present'.
#              Otherwise it will be set as 'absent'.
# [*conf_template*] - Path of the template of the barman.conf configuration
#                     file. The default value does not need to be changed.
# [*logrotate_template*] - Path of the template of the logrotate.conf file.
#                          The default value does not need to be changed.
# [*home*] - A different place for backups than the default. Will be symlinked
#            to the default (/var/lib/barman). You should not change this
#            value after the first setup. Its value is set by the 'settings'
#            class.
# [*logfile*] - A different log file. The default is
#               '/var/log/barman/barman.log'
# [*log_level*] - Level of logging. The default is INFO
#                 (DEBUG, INFO, WARNING, ERROR, CRITICAL). Global.
# [*archiver*] - Whether the log shipping backup mechanism is active or not
#                (defaults to true)
# [*archiver_batch_size*] - Setting this option enables batch processing of WAL
#                           files. The default processes all currently available
#                           files.
# [*backup_directory*] - Directory where backup data for a server will be placed.
# [*backup_method*] - Configure the method barman used for backup execution. If
#                     set to rsync (default), barman will execute backup using the
#                     rsync command. If set to postgres barman will use the
#                     pg_basebackup command to execute the backup.
# [*backup_options*] - Behavior for backup operations: possible values are
#                      exclusive_backup (default) and concurrent_backup.
# [*recovery_options*] - The restore command to write in the recovery.conf.
#                        Possible values are 'get-wal' and undef. Default: undef.
# [*bandwidth_limit*] - This option allows you to specify a maximum transfer rate
#                       in kilobytes per second. A value of zero specifies no
#                       limit (default).
# [*check_timeout*] - Maximum execution time, in seconds per server, for a barman
#                     check command. Set to 0 to disable the timeout. Positive
#                     integer, default 30.
# [*compression*] - Compression algorithm. Currently supports 'gzip' (default),
#                   'bzip2', and 'custom'. Disabled if false.
# [*custom_compression_filter*] - Customised compression algorithm applied to WAL
#                                 files.
# [*custom_decompression_filter*] - Customised decompression algorithm applied to
#                                   compressed WAL files; this must match the
#                                   compression algorithm.
# [*immediate_checkpoint*] - Force the checkpoint on the Postgres server to
#                            happen immediately and start your backup copy
#                            process as soon as possible. Disabled if false
#                           (default)
# [*basebackup_retry_times*] - Number of retries fo data copy during base
#                              backup after an error. Default = 0
# [*basebackup_retry_sleep*] - Number of seconds to wait after after a failed
#                              copy, before retrying. Default = 30
# [*minimum_redundancy*] - Minimum number of required backups (redundancy).
#                          Default = 0
# [*network_compression*] - This option allows you to enable data compression for
#                           network transfers. Defaults to false.
# [*parallel_jobs] - Number of parallel workers used to copy files during
#                    backup or recovery. Requires backup mode = rsync.
# [*path_prefix*] - One or more absolute paths, separated by colon, where Barman
#                   looks for executable files.
# [*last_backup_maximum_age*] - Time frame that must contain the latest backup
#                               date. If the latest backup is older than the
#                               time frame, barman check command will report an
#                               error to the user. Empty if false (default).
# [*post_archive_retry_script*] - Hook script launched after a WAL file is
#                                 archived by maintenance. Being this a retry hook
#                                 script, Barman will retry the execution of the
#                                 script until this either returns a SUCCESS (0),
#                                 an ABORT_CONTINUE (62) or an ABORT_STOP (63)
#                                 code. In a post archive scenario, ABORT_STOP has
#                                 currently the same effects as ABORT_CONTINUE.
# [*post_archive_script*] - Hook script launched after a WAL file is archived by
#                           maintenance, after 'post_archive_retry_script'.
# [*post_backup_retry_script*] - Hook script launched after a base backup. Being
#                                this a retry hook script, Barman will retry the
#                                execution of the script until this either returns
#                                a SUCCESS (0), an ABORT_CONTINUE (62) or an
#                                ABORT_STOP (63) code. In a post backup scenario,
#                                ABORT_STOP has currently the same effects as
#                                ABORT_CONTINUE.
# [*post_backup_script*] - Hook script launched after a base backup, after
#                          'post_backup_retry_script'.
# [*pre_archive_retry_script*] - Hook script launched before a WAL file is
#                                archived by maintenance, after
#                                'pre_archive_script'. Being this a retry hook
#                                script, Barman will retry the execution of the
#                                script until this either returns a SUCCESS (0),
#                                an ABORT_CONTINUE (62) or an ABORT_STOP (63)
#                                code. Returning ABORT_STOP will propagate the
#                                failure at a higher level and interrupt the WAL
#                                archiving operation.
# [*pre_archive_script*] - Hook script launched before a WAL file is archived by
# 			   maintenance.
# [*pre_backup_retry_script*] - Hook script launched before a base backup, after
#                               'pre_backup_script'. Being this a retry hook
#                               script, Barman will retry the execution of the
#                               script until this either returns a SUCCESS (0), an
#                               ABORT_CONTINUE (62) or an ABORT_STOP (63) code.
#                               Returning ABORT_STOP will propagate the failure at
#                               a higher level and interrupt the backup operation.
# [*pre_backup_script*] - Hook script launched before a base backup.
# [*retention_policy*] - Base backup retention policy, based on redundancy or
#                        recovery window. Default empty (no retention enforced).
#                        Value must be greater than or equal to the server
#                        minimum redundancy level (if not is is assigned to
#                        that value and a warning is generated).
# [*wal_retention_policy*] - WAL archive logs retention policy. Currently, the
#                            only allowed value for wal_retention_policy is the
#                            special value main, that maps the retention policy
#                            of archive logs to that of base backups.
# [*retention_policy_mode*] - Can only be set to auto (retention policies are
#                             automatically enforced by the barman cron command)
# [*reuse_backup*] - Incremental backup is a kind of full periodic backup which
#                    saves only data changes from the latest full backup
#                    available in the catalogue for a specific PostgreSQL
#                    server. Disabled if false. Default false.
# [*slot_name*] - Physical replication slot to be used by the receive-wal
#                 command when streaming_archiver is set to on. Requires
#                 postgreSQL >= 9.4. Default: undef (disabled).
# [*streaming_archiver*] - This option allows you to use the PostgreSQL's
#                          streaming protocol to receive transaction logs from a
#                          server. This activates connection checks as well as
#                          management (including compression) of WAL files. If
#                          set to off (default) barman will rely only on
#                          continuous archiving for a server WAL archive
#                          operations, eventually terminating any running
#                          pg_receivexlog for the server.
# [*streaming_archiver_batch_size*] - This option allows you to activate batch
#                                     processing of WAL files for the
#                                     streaming_archiver process, by setting it to
#                                     a value > 0. Otherwise, the traditional
#                                     unlimited processing of the WAL queue is
#                                     enabled.
# [*streaming_archiver_name*] - Identifier to be used as application_name by the
#                               receive-wal command. Only available with
#                               pg_receivexlog >= 9.3. By default it is set to
#                               barman_receive_wal.
# [*streaming_backup_name*] - Identifier to be used as application_name by the
#                             pg_basebackup command. Only available with
#                             pg_basebackup >= 9.3. By default it is set to
#                             barman_streaming_backup.
# [*streaming_conninfo*] - Connection string used by Barman to connect to the
#                          Postgres server via streaming replication protocol. By
#                          default it is set to the same value as *conninfo*.
# [*streaming_wals_directory*] - Directory where WAL files are streamed from the
#                                PostgreSQL server to Barman.
# [*tablespace_bandwidth_limit*] - This option allows you to specify a maximum
#                                  transfer rate in kilobytes per second, by
#                                  specifying a comma separated list of
#                                  tablespaces (pairs TBNAME:BWLIMIT). A value of
#                                  zero specifies no limit (default).
# [*custom_lines*] - DEPRECATED. Custom configuration directives (e.g. for
#                    custom compression). Defaults to empty.
# [*barman_fqdn*] - The fqdn of the Barman server. It will be exported in
#                   several resources in the PostgreSQL server. Puppet
#                   automatically set this.
# [*autoconfigure*] - This is the main parameter to enable the
#                     autoconfiguration of the backup of a given PostgreSQL
#                     server. Defaults to false.
# [*exported_ipaddress*] - The ipaddress exported to the PostgreSQL server
#                          during atutoconfiguration. Defaults to
#                          "${::ipaddress}/32".
# [*host_group*] -  Tag used to collect and export resources during
#                   autoconfiguration. Defaults to 'global'.
# [*manage_package_repo*] - Configure PGDG repository. It is implemented
#                           internally by declaring the `postgresql::globals`
#                           class. If you need to customize the
#                           `postgresql::globals` class declaration, keep the
#                           `manage_package_repo` parameter disabled in `barman`
#                           module and enable it directly in
#                           `postgresql::globals` class.
# [*manage_ssh_host_keys*] - When using autoconfigure, ensure the hosts contain
#                            each other ssh host key. Must also be set on
#                            'barman::postgres' class. Defaults to false.
# [*purge_unknown_conf*] - Whether or not barman conf files not included in
#                          puppetdb will be removed by puppet.
# [*servers*] - hiera hash to support the server define.
#               Defaults to undef.
#
# === Facts
#
# The module generates a fact called '*barman_key*' which has the content of
#  _/var/lib/barman/.ssh/id_rsa.pub_, in order to automatically handle the
#  key exchange on the postgres server via puppetdb.
# If the file doesn't exist, a key will be generated.
#
# === Examples
#
# The class can be used right away with defaults:
# ---
#  include barman
# ---
#
# All parameters that are supported by barman can be changed:
# ---
#  class { barman:
#    logfile  => '/var/log/barman/something_else.log',
#    compression => 'bzip2',
#    pre_backup_script => '/usr/bin/touch /tmp/started',
#    post_backup_script => '/usr/bin/touch /tmp/stopped',
#    custom_lines => '; something'
#  }
# ---
#
# === Authors
#
# * Giuseppe Broccolo <giuseppe.broccolo@2ndQuadrant.it>
# * Giulio Calacoci <giulio.calacoci@2ndQuadrant.it>
# * Francesco Canovai <francesco.canovai@2ndQuadrant.it>
# * Marco Nenciarini <marco.nenciarini@2ndQuadrant.it>
# * Gabriele Bartolini <gabriele.bartolini@2ndQuadrant.it>
# * Alessandro Grassi <alessandro.grassi@2ndQuadrant.it>
#
# Many thanks to Alessandro Franceschi <al@lab42.it>
#
# === Copyright
#
# Copyright 2012-2017 2ndQuadrant Italia
#
class barman (
  String $user                                                                   = $barman::settings::user,
  String $group                                                                  = $barman::settings::group,
  String $ensure                                                                 = 'present',
  String $conf_template                                                          = 'barman/barman.conf.erb',
  String $logrotate_template                                                     = 'barman/logrotate.conf.erb',
  String $barman_fqdn                                                            = $facts['networking']['fqdn'],
  Boolean $archiver                                                              = $barman::settings::archiver,
  Variant[Integer, Undef] $archiver_batch_size                                   = $barman::settings::archiver_batch_size,
  Boolean $autoconfigure                                                         = $barman::settings::autoconfigure,
  Variant[Pattern['^(rsync|postgres)$'], Undef] $backup_method                   = $barman::settings::backup_method,
  Pattern['^exclusive_backup$', '^concurrent_backup$'] $backup_options           = $barman::settings::backup_options,
  Integer $bandwidth_limit                                                       = $barman::settings::bandwidth_limit,
  Pattern['^[0-9]+$','^false$'] $basebackup_retry_sleep                          = $barman::settings::basebackup_retry_sleep,
  Pattern['^[0-9]+$','^false$'] $basebackup_retry_times                          = $barman::settings::basebackup_retry_times,
  Variant[Integer, Undef] $check_timeout                                         = $barman::settings::check_timeout,
  String $compression                                                            = $barman::settings::compression,
  Variant[String, Undef] $custom_compression_filter                              = $barman::settings::custom_compression_filter,
  Variant[String, Undef] $custom_decompression_filter                            = $barman::settings::custom_decompression_filter,
  String $exported_ipaddress                                                     = "${facts['networking']['ip']}/32",
  String $home                                                                   = $barman::settings::home,
  String $host_group                                                             = $barman::settings::host_group,
  Boolean $immediate_checkpoint                                                  = $barman::settings::immediate_checkpoint,
  Pattern['^[1-9][0-9]* (DAY|WEEK|MONTH)S?$','^false$'] $last_backup_maximum_age = $barman::settings::last_backup_maximum_age,
  String $logfile                                                                = $barman::settings::logfile,
  Variant[String, Undef] $log_level                                              = $barman::settings::log_level,
  Boolean $manage_package_repo                                                   = $barman::settings::manage_package_repo,
  Boolean$manage_ssh_host_keys                                                   = $barman::settings::manage_ssh_host_keys,
  Pattern['^[0-9]+$'] $minimum_redundancy                                        = $barman::settings::minimum_redundancy,
  Variant[Boolean, Undef] $network_compression                                   = $barman::settings::network_compression,
  Variant[Integer, Undef] $parallel_jobs                                         = $barman::settings::parallel_jobs,
  Variant[Stdlib::Absolutepath, Undef] $path_prefix                              = $barman::settings::path_prefix,
  Boolean $post_archive_retry_script                                             = $barman::settings::post_archive_retry_script,
  Boolean $post_archive_script                                                   = $barman::settings::post_archive_script,
  Boolean $post_backup_retry_script                                              = $barman::settings::post_backup_retry_script,
  Boolean $post_backup_script                                                    = $barman::settings::post_backup_script,
  Boolean $pre_archive_retry_script                                              = $barman::settings::pre_archive_retry_script,
  Boolean $pre_archive_script                                                    = $barman::settings::pre_archive_script,
  Boolean $pre_backup_retry_script                                               = $barman::settings::pre_backup_retry_script,
  Boolean $pre_backup_script                                                     = $barman::settings::pre_backup_script,
  Boolean $purge_unknown_conf                                                    = $barman::settings::purge_unknown_conf,
  Variant[Pattern['^get-wal$']] $recovery_options                                = $barman::settings::recovery_options,
  Pattern['^(^$|REDUNDANCY [1-9][0-9]*|RECOVERY WINDOW OF [1-9][0-9]* (DAY|WEEK|MONTH)S?)$'] $retention_policy = $barman::settings::retention_policy,
  Pattern['^auto$'] $retention_policy_mode                                                                     = $barman::settings::retention_policy_mode,
  Pattern['^(off|link|copy)$'] $reuse_backup                                                                   = $barman::settings::reuse_backup,
  Variant[String, Undef] $slot_name                                                                            = $barman::settings::slot_name,
  Boolean $streaming_archiver                                                                                  = $barman::settings::streaming_archiver,
  Integer $streaming_archiver_batch_size                                                                       = $barman::settings::streaming_archiver_batch_size,
  Variant[String, Undef] $streaming_archiver_name                                                              = $barman::settings::streaming_archiver_name,
  Variant[String, Undef] $streaming_backup_name                                                                = $barman::settings::streaming_backup_name,
  Variant[String, Undef] $tablespace_bandwidth_limit                                                           = $barman::settings::tablespace_bandwidth_limit,
  Pattern['^main$'] $wal_retention_policy                                                                      = $barman::settings::wal_retention_policy,
  String $custom_lines                                                                                         = $barman::settings::custom_lines,
  Variant[Hash, Undef] $servers                                                                                = undef,
) inherits barman::settings {
  # when hash data is in servers, then fire-off barman::server define with that hash data
  if ($servers) {
    create_resources('barman::server',
    deep_merge(hiera_hash('barman::servers', {}), $servers))
  }

  # Ensure creation (or removal) of Barman files and directories
  $ensure_file = $ensure ? {
    'absent' => 'absent',
    default  => 'present',
  }
  $ensure_directory = $ensure ? {
    'absent' => 'absent',
    default  => 'directory',
  }

  if $manage_package_repo {
    if defined(Class['postgresql::globals']) {
      fail('Class postgresql::globals is already defined. Set barman class manage_package_repo parameter to false (preferred) or remove the other definition.')
    } else {
      class { 'postgresql::globals':
        manage_package_repo => true,
      }
    }
  }
  package { 'barman':
    ensure => $ensure,
    tag    => 'postgresql',
  }

  file { '/etc/barman.conf.d':
    ensure  => $ensure_directory,
    purge   => $purge_unknown_conf,
    recurse => true,
    owner   => 'root',
    group   => $group,
    mode    => '0750',
    require => Package['barman'],
  }

  file { '/etc/barman.conf':
    ensure  => $ensure_file,
    owner   => 'root',
    group   => $group,
    mode    => '0640',
    content => template($conf_template),
    require => File['/etc/barman.conf.d'],
  }

  file { $home:
    ensure  => $ensure_directory,
    owner   => $user,
    group   => $group,
    mode    => '0750',
    require => Package['barman'],
  }

  if $manage_ssh_host_keys {
    file { "${home}/.ssh":
      ensure  => directory,
      owner   => $user,
      group   => $group,
      mode    => '0700',
      require => File[$home],
    }

    file { "${home}/.ssh/known_hosts":
      ensure => file,
      owner  => $user,
      group  => $group,
      mode   => '0600',
    }
  }

  # Run 'barman check all' to create Barman backup directories
  exec { 'barman-check-all':
    command     => '/usr/bin/barman check all',
    subscribe   => File[$home],
    refreshonly => true,
  }

  file { '/etc/logrotate.d/barman':
    ensure  => $ensure_file,
    owner   => 'root',
    group   => $group,
    mode    => '0644',
    content => template($logrotate_template),
    require => Package['barman'],
  }

  # Set the autoconfiguration
  if $autoconfigure {
    class { 'barman::autoconfigure':
      exported_ipaddress => $exported_ipaddress,
      host_group         => $host_group,
    }
  }
}

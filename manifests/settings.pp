# == Class: barman
#
# This class just contains default settings for the 'barman'
# Puppet module.
#
# NOTE: Parameters can be changed passing values by Hiera file.
#
# === Parameters
#
# [*user*] - The Barman user. The default value is 'barman'.
# [*group*] - The group of the Barman user. The default
#             value is 'barman'.
# [*dbuser*] - The user used by Barman to connect to
#              PostgreSQL database(s). It will be used to
#              build the 'conninfo' Barman parameter.
#              The default value is 'barman', and will be
#              the same for all the PostgreSQL servers.
# [*dbname*] - The database where Barman can connect. It will
#              be used to build the 'conninfo' Barman parameter.
#              The default one is the 'postgres' database.
# [*home*] - The Barman user home directory. The default
#            value is '/var/lib/barman', but it can be changed
#            depending on the operating system.
# [*autoconfigure*] - This is the main parameter to enable the
#                     autoconfiguration of the backup of a
#                     given postgreSQL server performed by
#                     Barman.
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
class barman::settings (
  String $user                                                                                                 = 'barman',
  String $group                                                                                                = 'barman',
  String $dbuser                                                                                               = 'barman',
  String $dbname                                                                                               = 'postgres',
  String $home                                                                                                 = '/var/lib/barman',
  Boolean $archiver                                                                                            = true,
  Variant[Integer, Undef] $archiver_batch_size                                                                 = undef,
  Variant[Pattern['^(rsync|postgres)$'], Undef] $backup_method                                                 = undef,
  Pattern['^exclusive_backup$', '^concurrent_backup$'] $backup_options                                         = 'exclusive_backup',
  Variant[Integer, Undef] $bandwidth_limit                                                                     = undef,
  Pattern['^[0-9]+$','^false$'] $basebackup_retry_sleep                                                        = false,
  Pattern['^[0-9]+$','^false$'] $basebackup_retry_times                                                        = false,
  Variant[Integer, Undef] $check_timeout                                                                       = undef,
  Variant[String, Undef] $custom_compression_filter                                                            = undef,
  Variant[String, Undef] $custom_decompression_filter                                                          = undef,
  String $compression                                                                                          = 'gzip',
  Boolean $immediate_checkpoint                                                                                = false,
  Pattern['^[1-9][0-9]* (DAY|WEEK|MONTH)S?$','^false$'] $last_backup_maximum_age                               = false,
  Stdlib::Absolutepath $logfile                                                                                = '/var/log/barman/barman.log',
  Variant[String, Undef] $log_level                                                                             = undef,
  Pattern['^[0-9]+$'] $minimum_redundancy                                                                      = '0',
  Variant[Boolean, Undef] $network_compression                                                                 = undef,
  Variant[Integer, Undef] $parallel_jobs                                                                       = undef,
  Variant[Stdlib::Absolutepath, Undef] $path_prefix                                                            = undef,
  Boolean $post_archive_retry_script                                                                           = false,
  Boolean $post_archive_script                                                                                 = false,
  Boolean $post_backup_retry_script                                                                            = false,
  Boolean $post_backup_script                                                                                  = false,
  Boolean $pre_archive_retry_script                                                                            = false,
  Boolean $pre_archive_script                                                                                  = false,
  Boolean $pre_backup_retry_script                                                                             = false,
  Boolean $pre_backup_script                                                                                   = false,
  Variant[Pattern['^get-wal$']] $recovery_options                                                              = undef,
  Pattern['^(^$|REDUNDANCY [1-9][0-9]*|RECOVERY WINDOW OF [1-9][0-9]* (DAY|WEEK|MONTH)S?)$'] $retention_policy = '',
  Pattern['^auto$'] $retention_policy_mode                                                                     = 'auto',
  Pattern['^(off|link|copy)$'] $reuse_backup                                                                   = false,
  Variant[String, Undef] $slot_name                                                                            = undef,
  Boolean $streaming_archiver                                                                                  = false,
  Integer $streaming_archiver_batch_size                                                                       = undef,
  Variant[String, Undef] $streaming_archiver_name                                                              = undef,
  Variant[String, Undef] $streaming_backup_name                                                                = undef,
  Variant[String, Undef] $tablespace_bandwidth_limit                                                           = undef,
  Pattern['^main$'] $wal_retention_policy                                                                      = 'main',
  String $custom_lines                                                                                         = '',
  Boolean $autoconfigure                                                                                       = false,
  String $host_group                                                                                           = 'global',
  Boolean $manage_package_repo                                                                                 = false,
  Boolean $manage_ssh_host_keys                                                                                = false,
  Boolean $purge_unknown_conf                                                                                  = false,
) {}

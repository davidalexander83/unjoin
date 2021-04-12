plan unjoin (
  TargetSpec $targets
) {
  # Install the puppet-agent package and gather facts
  $targets.apply_prep

  # Apply Puppet code
  $apply_results = apply($targets) {
      dsc_computer { 'Unjoin domain':
        dsc_name          => $facts['hostname'],
        dsc_workgroupname => 'NotDomain',
        dsc_credential    => {
          'user'          => 'mydomain\\domain_join',
          'password'      => Sensitive('Puppet4Life')
        },
      }
  }

  # Print log messages from the report
  $apply_results.each |$result| {
    $result.report['logs'].each |$log| {
      out::message("${log['level'].upcase}: ${log['message']}")
    }
  }

  run_plan('reboot', $targets)

}

#!/usr/bin/env ruby
require_relative 'config-lib.rb'
include BackupConfig

#
# restore-settings
#

# Perform restore
targets.each do |source, target|
  sanitized_source = File.dirname(BackupConfig.sanitise_path(source))
  puts "#{target} -> #{sanitized_source}" if verbose?
  unless dry_run?
    FileUtils.mkdir_p(File.dirname(sanitized_source))
    FileUtils.cp_r(target, sanitized_source, remove_destination: true) if File.exist? target
  end
end
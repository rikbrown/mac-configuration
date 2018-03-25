#!/usr/bin/env ruby
require_relative 'backup-config.rb'
include BackupConfig

#
# restore-settings
#

# Perform restore
targets.each do |source, target|
  puts "#{target} -> #{source}" if verbose?
  FileUtils.cp_r(target, BackupConfig.sanitise_path(source))
end
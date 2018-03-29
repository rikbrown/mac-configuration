#!/usr/bin/env ruby
require_relative 'config-lib.rb'
include BackupConfig

#
# restore-settings
#

# Perform restore
targets.each do |source, target|
  puts "#{target} -> #{source}" if verbose?
  FileUtils.cp_r(target, File.dirname(BackupConfig.sanitise_path(source)), remove_destination: true) if File.exist? source
end
#!/usr/bin/env ruby
require_relative 'backup-config.rb'
include BackupConfig

#
# backup-settings
#

# Perform backup
targets.each do |source, target|
  puts "#{source} -> #{target}" if verbose?
  FileUtils.mkdir_p(File.dirname(target))
  FileUtils.cp_r(sanitise_path(source), target)
end

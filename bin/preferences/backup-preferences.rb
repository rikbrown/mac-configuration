#!/usr/bin/env ruby
require_relative 'config-lib.rb'
include BackupConfig

#
# preferences-settings
#

# Perform preferences
targets.each do |source, target|
  puts "#{source} -> #{target}" if verbose?
  FileUtils.mkdir_p(File.dirname(target))
  FileUtils.cp_r(sanitise_path(source), target)
end

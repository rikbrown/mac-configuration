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

  FileUtils.rmtree(target)
  source = sanitise_path(source)
  FileUtils.cp_r(source, target) if File.exist? source
end

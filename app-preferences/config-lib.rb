require 'fileutils'
require 'yaml'
require 'optparse'

module BackupConfig
  CONFIG_FILE = File.join(__dir__, 'apps.yml')

  OPTIONS = {}.tap do |options|
    OptionParser.new do |opts|
      opts.on("-v", "--[no-]verbose", "Run verbosely") { |v| options[:verbose] = v }
    end.parse!
  end

  # @return [Boolean] should we be verbose?
  def verbose?; OPTIONS[:verbose]; end

  # Get preferences targets (source to target)
  # @return [Hash<String, String>]
  def targets
    BackupUtils.config.flat_map do |app, files|
      files.map { |file| [file, BackupUtils.backup_location(app, file)] }
    end.to_h
  end

  # Sanitise path, substituting ~ with home directory
  # @return [String]
  def sanitise_path(path); path.sub('~', Dir.home); end

  class BackupUtils
    class << self
      # Get preferences location for input app and file
      # @return [String]
      def backup_location(app, file)
        File.join(__dir__, 'preferences', app, File.basename(file))
      end

      # @return [Hash<String, Array<String>>]
      def config
        # noinspection RubyResolve
        YAML.load(File.open(CONFIG_FILE))
      end
    end
  end

end


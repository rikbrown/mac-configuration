require 'fileutils'
require 'yaml'
require 'optparse'

module BackupConfig
  CONFIG_FILE = File.join(__dir__, 'apps.yml')

  OPTIONS = {}.tap do |options|
    OptionParser.new do |opts|
      opts.on("-l", "--location LOCATION", "Location to backup/restore preferences") { |l| options[:location] = l }
      opts.on("-v", "--verbose", "Run verbosely") { |v| options[:verbose] = v }
      opts.on("-d", "--dry-run", "Dry run") { |v| options[:dry_run] = v }
    end.parse!
    raise OptionParser::MissingArgument if options[:location].nil?
  end

  # @return [Boolean] should we be verbose?
  def verbose?; OPTIONS[:verbose]; end

  # @return [Boolean] dry run?
  def dry_run?; OPTIONS[:dry_run]; end

  # Get preferences targets (source to target)
  # @return [Hash<String, String>]
  def targets
    BackupUtils.config.flat_map do |app, config|
      files = case config
                when Array then config
                when Hash then
                  # @type [Array<String>]
                  excluded_files = (config['exclude'] || []).flat_map do |loc|
                    Dir.glob(sanitise_path(loc))
                        .reject {|fn| File.directory?(fn) }
                  end

                  config['include']
                    .flat_map do |loc|
                      Dir.glob(sanitise_path(loc))
                        .reject { |fn| File.directory?(fn) }
                        .reject { |fn| excluded_files.include? fn }
                    end
                else raise "Invalid config: #{config}"
              end

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
        sanitized_file = file.sub('~', 'Home').sub(Dir.home, 'Home')
        File.join(OPTIONS[:location], app, sanitized_file)
      end

      # @return [Hash<String, Array<String>>]
      def config
        # noinspection RubyResolve
        YAML.load(File.open(CONFIG_FILE))
      end
    end
  end

end


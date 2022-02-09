require './src/scripts/base'
require './src/models/github/client'

class PullRequestCreator < Base

  DEFAULT_CONFIG = './config/pull_request_creator/settings.yml'

  def initialize(config)
    super()
    Settings.prepend_source!(File.expand_path(config, Dir.pwd))
    Settings.reload!
  end

  def execute
    p GitHub::Client.client.user
  end

  def self.default_config
    DEFAULT_CONFIG
  end
end

config_file = ARGV.size.zero? ? PullRequestCreator.default_config : ARGV[0]

PullRequestCreator.new(config_file).execute

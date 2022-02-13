require './src/scripts/base'
require './src/models/git/repository'
require './src/models/configuration/branch_creator'

class BranchCreator < Base
  DEFAULT_CONFIG = 'config/branch_creator/settings.yml'

  def initialize(config_file)
    super()
    @config = Configuration::BranchCreator.new(config_file)
  end

  def execute
    config.repositories.each do | repository_dir |
      repository_path = File.expand_path(repository_dir, Dir.pwd)
      repository = Git::Repository.new(repository_path)
      repository.branch.checkout!("feat/create_branch", "feat/create_branch_2")
    end
  end

  def config
    @config
  end

  def self.default_config
    DEFAULT_CONFIG
  end
end

config_file = ARGV.size.zero? ? BranchCreator.default_config : ARGV[0]

BranchCreator.new(config_file).execute

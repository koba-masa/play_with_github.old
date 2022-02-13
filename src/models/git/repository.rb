require 'git'
require 'logger'

require './src/models/git/branch'

module Git
  class Repository
    def initialize(repo_dir)
      Git.configure do | conf |
        conf.git_ssh = ssh_script
      end
      @repo_dir = repo_dir
    end

    def branch
      @branch ||= Git::Branch.new(client)
    end

    def ssh_script
      @ssh_script ||= File.expand_path(Settings.git.ssh.script, Dir.pwd)
    end

    private
    def client
      @client ||= Git.open(@repo_dir, :log => Logger.new(STDOUT))
    end
  end
end

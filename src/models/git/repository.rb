module Git
  class Repository
    def initialize(repo_dir)
      @repo_dir = repo_dir
    end

    def branch
      @branch ||= Git::Branch.new(client)
    end

    private
    def client
      @client ||= Git.open(@repo_dir, :log => Logger.new(STDOUT))
    end
  end
end

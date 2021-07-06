require 'git'

class LocalRepository
  def initialize(directory_path)
    @local_repo = Git.open(working_dir, :log => Logger.new(STDOUT))
  end
end
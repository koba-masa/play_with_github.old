require './src/scripts/base'
require './src/models/git/repository'

class BranchCreator
  def executor
    repo_dir = "/Users/koba-masa/Documents/04.develop/my_own_tool/play_with_github/tmp/repositories/play_with_github"
    repository = Git::Repository.new(repo_dir)
  end
end

BranchCreator.new.execute

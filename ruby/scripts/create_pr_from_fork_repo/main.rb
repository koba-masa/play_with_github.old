require 'git'

def main(branch_name)
  local_repo = Git.open(working_dir, :log => Logger.new(STDOUT))
  # fork先のリポジトリから対象のブランチをcheckout
  # 
end

main(ARGV[0])

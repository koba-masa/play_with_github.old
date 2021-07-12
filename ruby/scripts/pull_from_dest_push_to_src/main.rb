require 'git'
require 'logger'
require 'config'

def main(config)
  Config.load_and_set_settings(config)

  local_repo_dir = Settings.local_repository.path

  base = Git::Base.open(local_repo_dir)
  #base = Git::Base.open(local_repo_dir, :log => Logger.new(STDOUT))
  fetch(base)

  # fork元のリポジトリのブランチ一覧を取得
  remote_branches_dest = get_remote_branches(base, Settings.remote.dest)
  #remote_branches_dest.each { | branch | p branch.name }

  # fork元に存在するブランチをfork先にpush
  push_from_dest_to_src(base, remote_branches_dest)

  # fork先に存在し、fork元に存在しないリポジトリを削除
  remote_branches_src = get_remote_branches(base, Settings.remote.src)
  #remote_branches_src.each { | branch | p branch.name }
  delete_branch(base, remote_branches_src, remote_branches_dest)

end

def fetch(base)
  base.fetch(Settings.remote.dest, {:p => true})
  base.fetch(Settings.remote.src)
end

def get_remote_branches(base, remote_name)
  base.branches.remote.delete_if { | branch | !target_branch?(remote_name, branch) }
end

def target_branch?(remote_name, branch)
  return false if branch.remote.name != remote_name
  Settings.target.branch.each do | branch_name |
    return true if branch.name =~ /#{branch_name}/
  end
  return false
end

def push_from_dest_to_src(base, branches)
  remote_dest = Settings.remote.dest
  remote_src = Settings.remote.src

  branches.each do | branch|
    branch_name = branch.name
    base.checkout(branch_name)
    base.pull(remote_dest, branch_name)
    base.push(remote_src, branch_name)
    #base.push(remote_src, branch_name, {:n => true})
  end
end

def delete_branch(base, remote_branches_src, remote_branches_dest)
  remote_src = Settings.remote.src
  delete_branch = branch_list(remote_branches_src) - branch_list(remote_branches_dest)
  delete_branch.each do | branch_name |
    #p branch_name
    base.push(remote_src, branch_name, {:delete => true})
    #p base.branches[branch_name]
    base.branches[branch_name].delete()
  end
end

def branch_list(branches)
  branches.map do | branch |
    branch.name
  end
end

main(ARGV[0])

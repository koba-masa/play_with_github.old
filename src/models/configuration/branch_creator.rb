module Configuration
  class BranchCreator
    def initialize(config_file)
      Settings.prepend_source!(File.expand_path(config_file, Dir.pwd))
      Settings.reload!
    end

    def repositories
      Settings.branch_creator.repositories
    end
  end
end

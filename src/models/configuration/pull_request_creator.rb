require 'time'
module Configuration
  class PullRequestCreator
    def initialize(config_file)
      Settings.prepend_source!(File.expand_path(config_file, Dir.pwd))
      Settings.reload!
    end

    def base_branch
      Settings.pull_request_creator.base_branch
    end

    def repositories
      Settings.pull_request_creator.repositories
    end

    def type
      Settings.pull_request_creator.release.type
    end

    def type_name
      case type
      when 'normal'
        '通常'
      when 'emergency'
        '緊急'
      when 'monthly'
        '月次'
      end
    end

    def release_date
      @release_date ||= Time.parse(
        "#{Settings.pull_request_creator.release.date} #{Settings.pull_request_creator.release.time} +09:00"
      )
    end

    def template
      Settings.pull_request_creator.template
    end

    def release_branch_name
      return @release_branch_name unless @release_branch_name.nil? || @release_branch_name.empty?
      case type
      when 'normal'
        @release_branch_name = "release/#{release_date.strftime('%Y%m%d')}"
      when 'emergency'
        @release_branch_name = "release/#{release_date.strftime('%Y%m%d')}_emergency"
      when 'monthly'
        @release_branch_name = "release/monthly_update_#{release_date.strftime('%Y%m')}"
      end
      @release_branch_name
    end

    def incremented_version_pattern
      Settings.pull_request_creator.incremented_version_pattern
    end

    def tag_format
      Settings.pull_request_creator.tag_format
    end

  end
end

require 'erb'

require './src/scripts/base'
require './src/models/github/client'
require './src/models/github/pull_request'
require './src/models/github/tag'
require './src/models/github/issue'
require './src/models/configuration/pull_request_creator'


class PullRequestCreator < Base

  DEFAULT_CONFIG = 'config/pull_request_creator/settings.yml'
  ONE_DAY = 60 * 60 * 24

  def initialize(config_file)
    super()
    @config = Configuration::PullRequestCreator.new(config_file)
  end

  def execute
    head = merge_branch_is_empty? ? config.release_branch_name : config.pr_merge_branch
    config.repositories.each do | repository |
      paramters = {
        type_name: config.type_name,
        release_date: config.release_date,
        release_dead_date: dead_date,
      }

      paramters[:tag] = next_tag(repository)
      pr = GitHub::PullRequest.new(
        repository,
        config.base_branch,
        head
      )
      title = pr_title(paramters[:tag])
      pr.create!(title, nil, {draft: true, labels: config.pr_labels.join(',')})

      paramters[:pr_number] = pr.pull_request_number
      issue = create_issue(repository, paramters)

      paramters[:issue_number] = issue.issue_number
      body = pr_body(paramters)
      pr.update!(nil, body, nil)
    end
  end

  def create_issue(repository, paramters)
    issue = GitHub::Issue.new(
      repository,
      issue_title(paramters[:tag]),
      issue_body(paramters),
      {
        labels: config.issue_labels.join(',')
      }
    )
    issue.create!
    issue
  end

  def next_tag(repository)
    latest_tag = GitHub::Tag.new(repository).latest_tag
    latest_tag = latest_tag.gsub(/refs\/tags\//, '')
    incremented_version = /#{config.incremented_version_pattern}/.match(latest_tag)[1].to_i + 1
    format(config.tag_format, incremented_version)
  end

  def date_to_wday(date)
    %w[日 月 火 水 木 金 土][date.wday]
  end

  def merge_branch_is_empty?
    config.pr_merge_branch.nil? || config.pr_merge_branch.empty?
  end

  def dead_date
    return @dead_date unless @dead_date.nil? || @dead_date.empty?
    if config.release_date.monday?
      # 月曜日の場合は、3日前
      @dead_date = config.release_date - (ONE_DAY * 3)
    elsif config.release_date.sunday?
      # 日曜日の場合は、2日前
      @dead_date = config.release_date - (ONE_DAY * 2)
    else
      # それ以外は前日
      @dead_date = config.release_date - (ONE_DAY * 1)
    end
    @dead_date
  end

  def pr_title(tag)
    "[#{config.type_name}][#{tag}]#{config.release_date.strftime('%Y/%m/%d')}"
  end

  def pr_body(paramters)
    @pr_erb ||= File.read(File.expand_path(config.pr_template, Dir.pwd))
    ERB.new(@pr_erb).result(binding)
  end

  def issue_title(tag)
    "[#{config.type_name}][#{tag}]#{config.release_date.strftime('%Y/%m/%d')}"
  end

  def issue_body(paramters)
    @issue_erb ||= File.read(File.expand_path(config.issue_template, Dir.pwd))
    ERB.new(@issue_erb).result(binding)
  end

  def config
    @config
  end

  def self.default_config
    DEFAULT_CONFIG
  end
end

config_file = ARGV.size.zero? ? PullRequestCreator.default_config : ARGV[0]

PullRequestCreator.new(config_file).execute

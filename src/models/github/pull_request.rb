module GitHub
  class PullRequest
    def initialize(repository, base_branch, head, title, body)
      @repository = repository
      @base_branch = base_branch
      @head = head
      @title = title
      @body = body
    end

    def create!
      client.create_pull_request(
        @repository,
        @base_branch,
        @head,
        @title,
        @body
      )
    end

    def client
      @client ||= GitHub::Client.client
    end
  end
end

module GitHub
  class PullRequest
    def initialize(repository, base_branch, head)
      @repository = repository
      @base_branch = base_branch
      @head = head
    end

    def create!(title, body, options)
      @created_pull_request = client.create_pull_request(
        @repository,
        @base_branch,
        @head,
        title,
        body,
        options
      )
    end

    def update!(title, body, state)
      raise 'PR is not exists.' if created_pull_request.nil?

      @created_pull_request = client.update_pull_request(
        @repository,
        pull_request_number,
        {
          title: title,
          body: body,
          state: state,
        }
      )
    end

    def client
      @client ||= GitHub::Client.client
    end

    def created_pull_request
      @created_pull_request
    end

    def pull_request_number
      created_pull_request[:number]
    end
  end
end

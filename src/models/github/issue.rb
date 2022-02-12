module GitHub
  class Issue
    def initialize(repository, title, body, options)
      @repository = repository
      @title = title
      @body = body
      @options = options
    end

    def create!
      @created_issue = client.create_issue(
        @repository,
        @title,
        @body,
        @options
      )
    end

    def client
      @client ||= GitHub::Client.client
    end

    def created_issue
      @created_issue
    end

    def issue_number
      created_issue[:number]
    end
  end
end

module GitHub
  class Tag
    def initialize(repository)
      @repository = repository
    end

    def tags
      @tags ||= client.refs(@repository, 'tag')
    end

    def latest_tag
      tags.sort_by { | tag | tag[:ref] }.reverse[0][:ref]
    end

    def client
      @client ||= GitHub::Client.client
    end
  end
end

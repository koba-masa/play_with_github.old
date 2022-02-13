module Git
  class Branch
    def initialize(client)
      @client = client
    end

    def checkout!(base_branch, new_branch)
      client.checkout(base_branch)
      client.fetch
      client.pull
    end

    def commit
    end

    def push
    end

    def client
      @client
    end
  end
end

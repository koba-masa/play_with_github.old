module Git
  class Branch
    def initialize(client)
      @client = client
    end

    def checkout!(base_branch, new_branch=nil)
      client.checkout(base_branch)
      client.fetch
      client.pull
      client.checkout(new_branch) if new_branch.nil? || new_branch.empty?
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

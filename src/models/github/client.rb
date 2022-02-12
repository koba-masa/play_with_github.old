module GitHub
  class Client
    def self.client
      @client ||= Octokit::Client.new(:access_token => personal_access_token)
    end

    def self.personal_access_token
      Settings.github.personal_access_token
    end
  end
end

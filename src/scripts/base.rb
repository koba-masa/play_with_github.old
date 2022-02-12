require 'bundler/setup'

class Base
  def initialize
    Bundler.require(*[:default, :development])
    Config.load_and_set_settings(File.expand_path('./config/credential.yml', Dir.pwd))
  end
end

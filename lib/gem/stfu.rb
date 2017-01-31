require "rubygems/installer"

module Gem
  class STFU
    VERSION = "2.0.0"

    def self.stfu_path
      @stfu_path ||= File.join Gem.user_home, ".gem", "stfu.rc"
    end

    def self.stfu_list
      @stfu ||= if File.exist? stfu_path then
                  File.readlines(stfu_path).map(&:chomp)
                else
                  []
                end
    end

    def self.stfu? spec, message
      message == spec.post_install_message && self.stfu_list.include?(spec.name)
    end
  end
end

Gem::Installer.class_eval do
  def say(message)
    super unless Gem::STFU.stfu? spec, message
  end
end

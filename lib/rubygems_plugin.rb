require "octokit"

module Gem
  class Star
    attr_reader :installer

    def initialize(installer)
      @installer = installer
    end

    def star
      if repo = repository
        begin
          client = Octokit::Client.new netrc: true
          client.star repo
          puts "starred #{repo}"
        rescue => e
          puts "failed starring #{repo}, reason #{e}"
        end
      end
    end

  private

    def repository
      url = installer.spec.homepage
      if url =~ /\Ahttps?:\/\/([^.]+)?\.?github.com\/(.+)/
        if $1 == nil
          $2
        elsif $1 == 'www'
          $2
        else
          "#{$1}/#{$2}"
        end
      end
    end
  end
end

Gem.post_install do |installer|
  Gem::Star.new(installer).star
end

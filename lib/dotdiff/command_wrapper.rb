require 'shellwords'

module DotDiff
  class CommandWrapper
    attr_reader :message

    def run(base, new)
      output = `#{command(base, new)}`

      if output.empty?
        @failed = false
      else
        @failed = output.include?('FAILED')
        @message = output.split("\n").join(' ')
      end
    end

    def passed?
      !failed
    end

    def failed?
      @failed
    end

    private

    def command(base, new)
      "#{DotDiff.perceptual_diff_bin} #{Shellwords.escape(base)} #{Shellwords.escape(new)}"
    end
  end
end

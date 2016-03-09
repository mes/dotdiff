require 'shellwords'

module DotDiff
  class CommandWrapper
    attr_reader :message

    def run(base_image, new_image)
      output = `#{command(base_image, new_image)}`

      @ran_checks = true

      if output.include?('PASS:')
        @failed = false
      else
        @failed = true
        @message = output.split("\n").join(' ')
      end
    end

    def passed?
      !failed?
    end

    def failed?
      @ran_checks && @failed
    end

    def ran_checks
      @ran_checks
    end

    private

    def command(base_image, new_image)
      "#{DotDiff.perceptual_diff_bin} #{Shellwords.escape(base_image)} "\
        "#{Shellwords.escape(new_image)} -verbose"
    end
  end
end

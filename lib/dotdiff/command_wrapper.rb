require 'shellwords'

module DotDiff
  class CommandWrapper
    attr_reader :message

    def run(base_image, new_image)
      output = `#{command(base_image, new_image)}`

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

    def command(base_image, new_image)
      "#{DotDiff.perceptual_diff_bin} #{Shellwords.escape(base_image)} "\
        "#{Shellwords.escape(new_image)}"
    end
  end
end

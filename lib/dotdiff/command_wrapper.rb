require 'shellwords'

module DotDiff
  class CommandWrapper
    attr_reader :message

    def run(base_image, new_image, diff_image_path)
      output = run_command(base_image, new_image, diff_image_path)

      @ran_checks = true

      begin
        pixels = Float(output)

        if pixels && pixels <= DotDiff.pixel_threshold
          @failed = false
        else
          @failed = true
          @message = "Images are #{pixels} pixels different"
        end
      rescue ArgumentError => e
        @failed = true
        @message = output
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

    # For the tests
    def run_command(base_image, new_image, diff_image_path)
      `#{command(base_image, new_image, diff_image_path)}`.strip
    end

    def command(base_image, new_image, diff_image_path)
      "#{DotDiff.image_magick_diff_bin} #{DotDiff.image_magick_options} " \
      "#{Shellwords.escape(base_image)} #{Shellwords.escape(new_image)} " \
      "#{Shellwords.escape(diff_image_path)} 2>&1"
    end
  end
end
